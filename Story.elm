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
""",
  Replace """
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
## Your first device

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

## Your first device

A group of devices can be linked together in what is called a ``topology''.
"""]},
    image = "topology.png"
  }

samplerSinkStep : Layout
samplerSinkStep = ImageStep
  {
    header = HeaderPane {content = [Single """

## Your first device

To start with, we will construct a simple topology comprising of two elements:
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

## Creating the package

We then create the Sampler. At minimum you will need to implement the
Run() method, which is the one which is used to implement the event loop of
the device state machine.

"""]},
    leftPane = ShellPane {content = [Single """
$ cd O2
$ mkdir -p examples/tutorial-1
$ vim examples/tutorial-1/sampler.h
"""]},
    rightPane = EditorPane { content = [Single """
#ifndef ALICEO2TUTORIALSAMPLER_H_
#define ALICEO2TUTORIALSAMPLER_H_

#include "FairMQDevice.h"

class AliceO2TutorialSampler : public FairMQDevice
{
  public:
    AliceO2TutorialSampler();
  protected:
    virtual void Run();
};

#endif /* ALICEO2TUTORIALSAMPLER_H_ */]
"""],
    filename = "examples/tutorial-1/sampler.h"
    }
  }

samplerImplStep : Layout
samplerImplStep = TwoPanesStep
  {
    header = HeaderPane {content = [Single """

## Creating the package

In the run method you will actually make sure you will keep iterating
until the state machine does not exit from the `RUNNING` state.

In this example we constuct a simple "Hello world" message which we then
publish for subscribers to receive.

Notice the use of the `LOG(INFO)` facility to print out log messages for your
device.

"""]},
    leftPane = ShellPane {
      content = [
        Single "
$ vim examples/tutorial-1/sampler.h
"
        ]
   },
    rightPane = EditorPane {
      filename = "examples/tutorial-1/sampler.cxx",
      content = [Single """
#include <memory>

#include <boost/thread.hpp>

#include "Sampler.h"
#include "FairMQLogger.h"

void FairMQExample1Sampler::Run()
{
  while (CheckCurrentState(RUNNING))
  {
    boost::this_thread::sleep(boost::posix_time::milliseconds(1000));

    std::string text = "Hello world";

    std::unique_ptr<FairMQMessage> msg(
      fTransportFactory->CreateMessage(const_cast<char*>(text.c_str()),
                                       text.length(), 0, text));

    LOG(INFO) << "Sending \"" << text << "\"";

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

## Creating the package

Similarly for the Sink, we must derive from `FairMQDevice` and implement the
`Run()` method.

In this case the implementation will simply receive the messages and
print them out.

"""]},
    leftPane = EditorPane {
      filename = "examples/tutorial-1/sink.h",
      content = [
        Single """
#ifndef FAIRMQEXAMPLE1SINK_H_
#define FAIRMQEXAMPLE1SINK_H_

#include "FairMQDevice.h"

class FairMQExample1Sink : public FairMQDevice
{
  public:
    FairMQExample1Sink();
    virtual ~FairMQExample1Sink();

  protected:
    virtual void Run();
};

#endif /* FAIRMQEXAMPLE1SINK_H_ */
"""]},
    rightPane = EditorPane {
      filename = "examples/tutorial-1/sink.cxx",
      content = [Single """
#include <memory>

#include <boost/thread.hpp>

#include "Sampler.h"
#include "FairMQLogger.h"

void FairMQExample1Sampler::Run()
{
  while (CheckCurrentState(RUNNING))
  {
    boost::this_thread::sleep(boost::posix_time::milliseconds(1000));

    std::string text = "Hello world";

    std::unique_ptr<FairMQMessage> msg(
      fTransportFactory->CreateMessage(const_cast<char*>(text.c_str()),
                                       text.length(), 0, text));

    LOG(INFO) << "Sending \"" << text << "\"";

    fChannels.at("data-out").at(0).Send(msg);
  }
}
"""]
    }
  }

applicationsStep: Layout
applicationsStep = TwoPanesStep
  {
    header = HeaderPane { content = [Single """

## Creating the driver processes

Now that we have our own devices, we need to create some boilerplate to be able to pass them
(optional) arguments and launch them:

"""]},
    leftPane = EditorPane {
      filename = "examples/tutorial-1/runSampler.h",
      content = [ Single """
#include <iostream>

#include "boost/program_options.hpp"

#include "FairMQLogger.h"
#include "FairMQParser.h"
#include "FairMQProgOptions.h"
#include "FairMQExample1Sampler.h"

using namespace boost::program_options;

int main(int argc, char** argv)
{
    FairMQExample1Sampler sampler;
    sampler.CatchSignals();

    FairMQProgOptions config;

    try
    {
        std::string text;

        options_description samplerOptions("Sampler options");
        samplerOptions.add_options()
            ("text", value<std::string>(&text)->default_value("Hello"), "Text to send out");

        config.AddToCmdLineOptions(samplerOptions);

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

        sampler.SetProperty(FairMQExample1Sampler::Id, id);
        sampler.SetProperty(FairMQExample1Sampler::Text, text);

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
#include "FairMQExample1Sink.h"

int main(int argc, char** argv)
{
    FairMQExample1Sink sink;
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

        sink.SetProperty(FairMQExample1Sink::Id, id);

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