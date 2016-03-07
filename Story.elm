module Story where

import DataModel exposing (..)

welcomeStep : Layout
welcomeStep = SinglePaneStep
  {
    header = HeaderPane {content = [Single """
## Welcome to the ALICE O2 Primer tutorial.""", Append """

The purpose of this tutorial is to guide you step by step through the set up of
your O2 working environment, the creation of your own FairRoot devices and
their deployment using DDS.

**Now lets get started!**
""", Append """
First of all this tutorial assumes you are in `~/alice` and that's
what we will use as a workarea. Notice that we set the `WORK_DIR`
environment variable to it.
"""]},
    pane = ShellPane { content = [Single "\n$\n", Reuse, Replace """
$ mkdir -p ~/alice 

$ cd ~ ~/alice

$ pwd
/Users/me/alice

$ export WORK_DIR=$PWD
"""] }
  }

checkoutStep : Layout
checkoutStep = SinglePaneStep
  {
    header = HeaderPane {content = [Single """
## Setting up your environment

The first thing to do is make sure you have O2 and all
the required software installed. To do so you can use
[aliBuild](http://alisw.github.io/alibuild/) a simple script which will
build everything and provide you with an easy to setup work environment.

""",
  Append "alibuild is hosted on Github and you can easily get it using `git clone`.",
  Append """
  Once you have downloaded alibuild itself, you need to download the
recipes which describe your software distribution, these are maintained in a separate project
called `alidist`.
""", Append """Since in this particular case we want to also develop
inside O2, we checkout its sources making sure they are at the same
level as `alidist`. Notice how we pick up the `dev` branch for
development.
""", Replace """
## Building the software

You can build the software by issuing the `aliBuild build` command.
`aliBuild` will try its best to reuse what you have on your system and
(eventually) download prebuild software instead of recompiling. You can find in depth documentation for alibuild at
<https://alisw.github.io/alibuild>.
"""
  ]},
    pane = ShellPane {
      content = [ Single """
$
""",
                  Single """
$ git clone https://github.com/alisw/alibuild
""",
                  Append """
$ git clone https://github.com/alisw/alidist
""",              Append """
$ git clone -b dev https://github.com/AliceO2Group O2
""",
                  Append """
$ alibuild/aliBuild build O2
"""
  ]}
  }

directoryStep : Layout
directoryStep = SinglePaneStep
  {
    header = HeaderPane {content = [Single """
## Directory structure

After a few minutes of building, aliBuild should finish successfully
and you should be left with an "sw" folder where the O2 software is
installed.""",
  Append """Alibuild builds each package in a separate hierarcy
`sw/<architecture>/<package>/<version>` where:
- `<architecture>` is the architecture of your platform (e.g.
`osx_x86-64`, `slc7_x86-64` or `ubuntu1510_x86-64`).""", 
  Append """
- `<package>` is the name of the package.""", 
  Append """
- `<version>` is the version of the package.
"""]},
    pane = ShellPane { content = [ Single """
$ ls sw
BUILD       INSTALLROOT MIRROR      SOURCES
SPECS       TARS        osx_x86-64
""", Append """
$ ls sw/osx_x86-64
AliEn-CAs             GEANT3                MonALISA-gSOAP-client cgal                  nanomsg
AliEn-Runtime         GEANT4                O2                    defaults-release      protobuf
AliPhysics            GEANT4_VMC            ROOT                  fastjet               pythia
AliRoot               GMP                   UUID                  gSOAP                 pythia6
ApMon-CPP             GSL                   XRootD                generators            simulation
DDS                   HepMC                 ZeroMQ                glog                  sodium
FairRoot              MPFR                  boost                 lhapdf                xalienfs
""", ReplaceLast """
$ ls sw/osx_x86-64
...                   AliPhysics            AliRoot               O2 ...              

$ ls sw/osx_x86-64/O2
latest   master-1 master-2
""", Append """
$ ls sw/osx_x86-64/O2/latest
bin            etc            include        lib            relocate-me.sh share
"""]
    }
  }

develStep: Layout
develStep = SinglePaneStep
  {
    header = HeaderPane { content = [Single """
## Developing O2

What we have done so far is useful if you just plan to simply run
executables provided by O2. In case you want to actually develop O2,
or any of it's dependencies, you actually need to check it out at the same level as
`alidist`.
"""]},
    pane = ShellPane { content = [ Single """
$ git clone https://github.com/alisw/alibuild
$ git clone https://github.com/alisw/alidist
$ git clone https://github.com/AliceO2Group/AliceO2
$ alibuild build O2
"""] }
  }

environmentStep: Layout
environmentStep = SinglePaneStep
  {
    header = HeaderPane { content = [Single """
## Setting up the environment

Once we have our O2 software built, we need to set up the environment in order to run O2 executables.
""", Append """
For each of the packages it builds, alibuild creates an `init.sh` file in `<package>`/etc/init.sh which
once sourced will set up all the required paths for the package itself and its dependencies.
""", Append """
You can verify you have the correct environment by looking for some of the pre-built O2 utilities.
"""]},
    pane = ShellPane {content = [ Single"""
$ ls sw/osx_x86-64/O2/latest
bin            etc            include        lib            relocate-me.sh share
""", Append """
$ ls $PWD/sw/osx_x86-64/O2/latest/etc/profile.d/init.sh
/Users/me/alice/sw/osx_x86-64/O2/latest/etc/profile.d/init.sh
""", Append """
$ WORK_DIR=$PWD/sw source sw/osx_x86-64/O2/latest/etc/profile.d/init.sh
""", Append """
$ which testFlp
/Users/me/alice/sw/osx_x86-64/O2/master-1/bin/testFlp

$ which dds-server
""" ] }
  }

deviceStep : Layout
deviceStep = ImageStep
  {
    header = HeaderPane { content = [Single """
## O2 / FairRoot architecture : Devices

Let's now try to create a new O2 process which does some sort of
data-processing. O2 describes processing workflows in terms of so called
devices. Devices are instances of the `FairMQDevice` class and they
provide implement computation and communication with other devices.
"""]},
    image = "device.png"
  }

topologyStep : Layout
topologyStep = ImageStep
  {
    header = HeaderPane { content = [Single """

## O2 / FairRoot architecture : Topologies

A group of devices can be linked together in what is called a ``topology''.
"""]},
    image = "topology.png"
  }

samplerSinkStep : Layout
samplerSinkStep = ImageStep
  {
    header = HeaderPane {content = [Single """

## Your first topology

To start with, we will construct a simple topology comprising of two devices:
- a "Sampler" which produces "hello world" objects
- a "Sink" which consumes them

The source code for this example is at <https://github.com/FairRootGroup/FairRoot/tree/master/examples/MQ/1-sampler-sink>.

"""]},
    image = "sampler-sink.png"
  }

samplerEnvStep : Layout
samplerEnvStep = SinglePaneStep
  {
    header = HeaderPane { content = [Single """

## Creating the package

In order to create our devices, lets first create a package where we put
all the required sources.

"""]},
    pane = ShellPane {content = [ Single """
$ cd O2
$ mkdir -p examples/tutorial-1
"""] }
  }

samplerHeaderStep : Layout
samplerHeaderStep = TwoPanesStep
  {
    header = HeaderPane {content = [Single """

## The Sampler

We then create the Sampler. At minimum you will need to implement the
`Run()` method, which is used to implement the message handling loop of
the device.

"""]},
    leftPane = ShellPane {content = [Single """
$ cd O2
$ mkdir -p examples/tutorial-1
$ vim examples/tutorial-1/AliceO2TutorialSampler.h
"""]},
    rightPane = EditorPane { content = [Single """
#ifndef ALICEO2TUTORIALSAMPLER_H_
#define ALICEO2TUTORIALSAMPLER_H_

#include "FairMQDevice.h"

class AliceO2TutorialSampler : public FairMQDevice
{
  protected:
    virtual void Run();
};

#endif /* ALICEO2TUTORIALSAMPLER_H_ */
"""],
    filename = "examples/tutorial-1/AliceO2TutorialSampler.h"
    }
  }

samplerImplStep : Layout
samplerImplStep = TwoPanesStep
  {
    header = HeaderPane {content = [Single """

## The Sampler

We now pass to the implementation of the `Run()` method.
""", Append """
First the `Run()` method we will actually make sure you will keep iterating
until the state machine does not exit from the `RUNNING` state.
""", ReplaceLast """
Inside this loop we construct a simple "Hello world" message which will
then published for subscribers to receive.
""", ReplaceLastN 3 """

## The Sampler

The full code for our Sampler device is the following. Copy and paste
it in the correct place. Notice the use of the `LOG(INFO)` facility to
handle debug / informative messages and the fact that we artificially
limit the rate to one per second.
""", Append """
Once we have implemented the sampler class we need to actually create an 
executable which instanciates our device.
"""]},
    leftPane = ShellPane {
      content = [
        Single "
$ vim examples/tutorial-1/AliceO2TutorialSampler.cxx
"
        ]
   },
    rightPane = EditorPane {
      filename = "examples/tutorial-1/AliceO2TutorialSampler.cxx",
      content = [Single "", Single """ 
...

void AliceO2TutorialSampler::Run()
{
  while (CheckCurrentState(RUNNING))
  {
    ...
  }
}

...
""", Single """
...

std::string text = "Hello world";

std::unique_ptr<FairMQMessage> msg(
  fTransportFactory->CreateMessage(const_cast<char*>(text.c_str()),
                                   text.length()));

fChannels.at("data-out").at(0).Send(msg);

...
""", Single """
#include <memory>

#include <boost/thread.hpp>

#include "AliceO2TutorialSampler.h"
#include "FairMQLogger.h"

void AliceO2TutorialSampler::Run()
{
  while (CheckCurrentState(RUNNING))
  {
    boost::this_thread::sleep(boost::posix_time::milliseconds(1000));

    std::string text = "Hello world";

    std::unique_ptr<FairMQMessage> msg(
      fTransportFactory->CreateMessage(const_cast<char*>(text.c_str()),
                                       text.length()));

    LOG(INFO) << "Sending \\"" << text << "\\"";

    fChannels.at("data-out").at(0).Send(msg);
  }
}
"""]
    }
  }

sinkHeaderStep : Layout
sinkHeaderStep = TwoPanesStep
  {
    header = HeaderPane { content = [Single """

## The Sink

Also for the Sink, we must derive from `FairMQDevice` and implement the
`Run()` method.

In this case the implementation will simply receive the messages and
print them out. This is done by invoking the `Receive()` method of the
channel.

""", Append """ The rest of the code is similar to the Sampler one, with 
the inner loop for the `RUNNING` state.

"""]},
    leftPane = EditorPane {
      filename = "examples/tutorial-1/AliceO2TutorialSink.h",
      content = [
        Single """
#ifndef ALICEO2TUTORIALSINK_H_
#define ALICEO2TUTORIALSINK_H_

#include "FairMQDevice.h"

class AliceO2TutorialSink : public FairMQDevice
{
  protected:
    virtual void Run();
};

#endif /* ALICEO2TUTORIALSINK_H_ */
"""]},
    rightPane = EditorPane {
      filename = "examples/tutorial-1/AliceO2TutorialSink.cxx",
      content = [Single """
...
unique_ptr<FairMQMessage> msg(fTransportFactory->CreateMessage());

if (fChannels.at("data-in").at(0).Receive(msg) >= 0)
{
    LOG(INFO) << "Received message: \\""
              << string(static_cast<char*>(msg->GetData()), msg->GetSize())
              << "\\"";
}
...
""", Single """
#include "AliceO2TutorialSink.h"
#include "FairMQLogger.h"

using namespace std;

void AliceO2TutorialSink::Run()
{
    while (CheckCurrentState(RUNNING))
    {
        unique_ptr<FairMQMessage> msg(fTransportFactory->CreateMessage());

        if (fChannels.at("data-in").at(0).Receive(msg) >= 0)
        {
            LOG(INFO) << "Received message: \\""
                      << string(static_cast<char*>(msg->GetData()), msg->GetSize())
                      << "\\"";
        }
    }
}
"""]
    }
  }

applicationsStep: Layout
applicationsStep = SinglePaneStep
  {
    header = HeaderPane { content = [Single """

## Creating the driver processes

Now that we have two classes for our own `FairMQDevice`s, we need to
create some boilerplate to be able to pass the (optional) arguments and
launch start the devices. We will call these two executable `runSampler`
and `runSink` respectively.

""", Replace """
## Creating the driver processes

First of all the driver is responsible to instanciate the devices and
the configuration option parser. We call the `CatchSignals()` method
of the `FairMQDevice` class to make sure that exceptions are properly
handled as `std::exceptions.`
""", ReplaceLast """
## Creating the driver processes

As part of the initialization the driver needs to:
- Parse the configuration.
""", Append """- Create the map of channel from the configuration.
""", Append """- Set the transport type and any other option found in the
configuration.
""", Append """- Initialise and transition the state machine until the
main loop is reached.
"""]},
    pane = EditorPane {
      filename = "examples/tutorial-1/runSampler.cxx",
      content = [ Single """
""", Single """
...
int main(int argc, char** argv)
{
  AliceO2TutorialSampler sampler;
  sampler.CatchSignals();

  FairMQProgOptions config;

  try
  {
    if (config.ParseAll(argc, argv))
      return 0;
    ...
  }
  catch (std::exception& e)
  {
    LOG(ERROR) << e.what();
    LOG(INFO) << "Command line options are the following: ";
    config.PrintHelp();
    return 1;
  }
  return 0;
}
""", Single """ 
...

std::string filename = config.GetValue<std::string>("config-json-file");
std::string id = config.GetValue<std::string>("id");

config.UserParser<FairMQParser::JSON>(filename, id);
""", Append """
sampler.fChannels = config.GetFairMQMap();
""", Append """
sampler.SetTransport(config.GetValue<std::string>("transport"));
sampler.SetProperty(AliceO2TutorialSampler::Id, id);
""", Append """
sampler.ChangeState("INIT_DEVICE");
sampler.WaitForEndOfState("INIT_DEVICE");

sampler.ChangeState("INIT_TASK");
sampler.WaitForEndOfState("INIT_TASK");

sampler.ChangeState("RUN");
sampler.InteractiveStateLoop();
"""]}
  }


finalAppStep = TwoPanesStep {
  header = HeaderPane {content = [Single """
  ## Creating the driver processes

  The final sourcecode for the sampler can be found below with the similar one for the sink.
  """]} ,
  leftPane = EditorPane {
    filename = "examples/tutorial-1/runSampler.cxx",
    content = [Single """
#include <iostream>

#include "boost/program_options.hpp"

#include "FairMQLogger.h"
#include "FairMQParser.h"
#include "FairMQProgOptions.h"
#include "AliceO2TutorialSampler.h"

using namespace boost::program_options;

int main(int argc, char** argv)
{
    AliceO2TutorialSampler sampler;
    sampler.CatchSignals();

    FairMQProgOptions config;

    try
    {
        if (config.ParseAll(argc, argv))
        {
            return 0;
        }

        std::string filename = config.GetValue<std::string>("config-json-file");
        std::string id = config.GetValue<std::string>("id");

        config.UserParser<FairMQParser::JSON>(filename, id);

        sampler.fChannels = config.GetFairMQMap();

        LOG(INFO) << "PID: " << getpid();

        sampler.SetTransport(config.GetValue<std::string>("transport"));

        sampler.SetProperty(AliceO2TutorialSampler::Id, id);

        sampler.ChangeState("INIT_DEVICE");
        sampler.WaitForEndOfState("INIT_DEVICE");

        sampler.ChangeState("INIT_TASK");
        sampler.WaitForEndOfState("INIT_TASK");

        sampler.ChangeState("RUN");
        sampler.InteractiveStateLoop();
    }
    catch (std::exception& e)
    {
        LOG(ERROR) << e.what();
        LOG(INFO) << "Command line options are the following: ";
        config.PrintHelp();
        return 1;
    }

    return 0;
}
"""] },
    rightPane = EditorPane {
      filename = "examples/tutorial-1/runSink.cxx",
      content = [ Single """
#include <iostream>

#include "FairMQLogger.h"
#include "FairMQParser.h"
#include "FairMQProgOptions.h"
#include "AliceO2TutorialSink.h"

int main(int argc, char** argv)
{
    AliceO2TutorialSink sink;
    sink.CatchSignals();

    FairMQProgOptions config;

    try
    {
        if (config.ParseAll(argc, argv))
        {
            return 0;
        }

        std::string filename = config.GetValue<std::string>("config-json-file");
        std::string id = config.GetValue<std::string>("id");

        config.UserParser<FairMQParser::JSON>(filename, id);

        sink.fChannels = config.GetFairMQMap();

        LOG(INFO) << "PID: " << getpid();

        sink.SetTransport(config.GetValue<std::string>("transport"));

        sink.SetProperty(AliceO2TutorialSink::Id, id);

        sink.ChangeState("INIT_DEVICE");
        sink.WaitForEndOfState("INIT_DEVICE");

        sink.ChangeState("INIT_TASK");
        sink.WaitForEndOfState("INIT_TASK");

        sink.ChangeState("RUN");
        sink.InteractiveStateLoop();
    }
    catch (std::exception& e)
    {
        LOG(ERROR) << e.what();
        LOG(INFO) << "Command line options are the following: ";
        config.PrintHelp();
        return 1;
    }

    return 0;
}
"""]
    }
  }

compiling = TwoPanesStep {
    header = HeaderPane { content = [Single """## Compiling

In order to compile in Alice O2 we rely on [CMake](https://cmake.org). You will need
to add a `examples/tutorial-1/CMakeLists.txt` which specifies how to compile the to Device
driver processes.
""", Append """In order to build you need to move to the
`sw/BUILD/O2-latest/O2` directory and type make.
"""]},
    leftPane = ShellPane { 
      content = [Single """
$ vim examples/tutorial-1/CMakeLists.txt
""",Append """
$ cd sw/BUILD/O2-latest/O2
$ make -j 10 install
...
[ 73%] Built target aliceHLTEventSampler
[ 74%] Built target aliceHLTWrapper
[ 76%] Built target runComponent
[ 88%] Built target AliceO2Cdb
[ 90%] Built target conditions-client
[ 91%] Built target conditions-server
[ 91%] Built target libAliceO2Cdb.rootmap
[ 94%] Built target runSampler
[ 96%] Built target runSink
[ 97%] Built target libtestits.rootmap
[100%] Built target testits
$ 
""", Replace """
$ which runSampler && which runSink"""],
    },
    rightPane = EditorPane { 
      filename = "examples/tutorial-1/CMakeLists.txt",
      content = [Single """
include_directories(
  ${FAIRROOT_ROOT}/include
  ${Boost_INCLUDE_DIR}
  ${FAIRROOT_INCLUDE_DIR} 
  ${CMAKE_SOURCE_DIR}/examples/tutorial-1
)

link_directories(
  ${Boost_LIBRARY_DIRS}
  ${FAIRROOT_LIBRARY_DIR} 
)

add_executable(runSink runSink.cxx AliceO2TutorialSink.cxx)
target_link_libraries(runSink FairMQ 
                              boost_log
                              boost_thread
                              boost_system
                              boost_program_options
                              fairmq_logger)
add_executable(runSampler runSampler.cxx AliceO2TutorialSampler.cxx)
target_link_libraries(runSampler FairMQ 
                                 boost_log
                                 boost_thread
                                 boost_system
                                 boost_program_options
                                 fairmq_logger)
install(TARGETS runSampler runSink
        RUNTIME DESTINATION bin)
"""]
    }
  }

running = TwoPanesStep {
    header = HeaderPane { content = [Single """## Running

""", Append """In order to build you need to move to the
`sw/BUILD/O2-latest/O2` directory and type make.
"""]},
    leftPane = ShellPane { 
      content = [Single """
"""],
    },
    rightPane = EditorPane { 
      filename = "examples/tutorial-1/config.json",
      content = [Single """
"""]
    }
  }

theend = SinglePaneStep {
      header = HeaderPane { content = [Single """## Final words
  In this tutorial we have seens how to setup your work environment,
  how to create a couple of FairRoot devices and run them both standalone
  and (soon) using DDS. You are now encouraged to look at the other FairRoot
  tutorials:

  <https://github.com/FairRootGroup/FairRoot/tree/master/examples>

"""]},
      pane = ShellPane { 
        content = [Single """
  """],
    }
  }
