module O2Tutorial where

import Html exposing (..)
import Keyboard
import Markdown
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import StartApp exposing(App)
import Array exposing (Array, get)
import Task exposing (..)
import Effects exposing (Effects, Never)
import RouteHash
import String exposing (toInt)
import Signal exposing (..)
import TutorialStyles.Styles exposing(..)
import DataModel exposing (..)

render : Pane -> List Html
render pane = 
  case pane of
    ShellPane a -> [
        div [shellTabStyle] [ span [titleStyle] [text "Welcome to Alice O2"]],
        div [shellStyle] [Markdown.toHtml("```\n" ++ a.shell ++ "```")]
      ]
    EditorPane a -> [ 
        div [shellTabStyle] [ span [titleStyle] [text a.filename]],
        div [editorStyle] [pre [] [code [class "lang-cpp"] [text (String.trim a.editor)]]]
      ]


singlePaneBackground : SinglePaneStep -> Background
singlePaneBackground step =
  {
    template = div [] [
      div [headerStyle] [Markdown.toHtml(step.header)],
      div [bodyStyle] 
        [
          div [class "pure-g"] [
            div [class "pure-u-1-24"] [],
            div [class "pure-u-22-24"]
              (render step.pane),
            div [class "pure-u-1-24"] []
          ]
        ]
    ]
  }

twoPanesBackground : TwoPanesStep -> Background
twoPanesBackground step =
  {
    template =
      div [] [
        div [headerStyle] [Markdown.toHtml(step.header)],
        div [bodyStyle] 
          [ 
            div [class "pure-g", innerStyle] [
              div [class "pure-u-1-2"] [
                div [style [("padding-right", "15px")] ]
                  (render step.leftPane)
              ],
              div [class "pure-u-1-2"] [
                div [style [("padding-left", "15px")] ]
                  (render step.rightPane)
              ]
            ]
          ],
        div [] []
      ]
  }

imageBackground : ImageStep -> Background
imageBackground step =
  {
    template = div [] [
      div [headerStyle] [Markdown.toHtml(step.header)],
      div [bodyStyle] 
        [ 
          div [class "pure-g"] [
            div [innerStyle, class "pure-u-1"] [
              img [src step.image, class "pure-img"] [text "A test image"]
            ]
          ]
        ],
      div [] []
    ]
  }

welcomeStep : SinglePaneStep
welcomeStep = 
  {
    header = """
## Welcome to the ALICE O2 Primer tutorial.

The purpose of this tutorial is to guide you step by step through the set up of
your O2 working environment, the creation of your own FairRoot devices and 
their deployment using DDS.

Now lets get started!
""",
    pane = ShellPane { shell = """
$
""" }
  }

checkoutStep : SinglePaneStep
checkoutStep = 
  {
    header = """
## Setting up your environment

The first thing to do is make sure you have O2 and all
the required software installed. To do so you can use
[aliBuild](http://alisw.github.io/alibuild/) a simple script which,
given a set of build recipe, will build everything and provide you with 
an easy to setup work environment.

""",
    pane = ShellPane { shell = """
$ git clone https://github.com/alisw/alibuild
$ git clone https://github.com/alisw/alidist
""" }
  }

buildStep : SinglePaneStep
buildStep =
  {
    header = """
## Building the software

You can build the software by issuing the `aliBuild build` command.
`aliBuild` will try its best to reuse what you have on your system and
(eventually) download prebuild software instead of recompiling.
""",
    pane = ShellPane { shell = """
$ git clone https://github.com/alisw/alibuild
$ git clone https://github.com/alisw/alidist
$ alibuild build O2
""" }
  }

directoryStep : SinglePaneStep
directoryStep =
  {
    header = """
## Directory structure

After a few minutes of building, aliBuild should finish successfully
and you should be left with an "sw" folder where the O2 software is
installed. Alibuild builds each dependency in a separate hierarcy
`sw/<architecture>/<package>/<version>` where:
- `<architecture>` is the architecture of your platform (e.g.
`osx_x86-64`, `slc7_x86-64` or `ubuntu1510_x86-64`). 
- `<package>` is the name of the package.
- `<version>` is the version of the package.
""",
    pane = ShellPane { shell = """
$ ls sw
BUILD       INSTALLROOT MIRROR      SOURCES     
SPECS       TARS        osx_x86-64

$ ls sw/osx_x86-64
AliEn-CAs             GEANT3                MonALISA-gSOAP-client cgal                  nanomsg
AliEn-Runtime         GEANT4                O2                    defaults-release      protobuf
AliPhysics            GEANT4_VMC            ROOT                  fastjet               pythia
AliRoot               GMP                   UUID                  gSOAP                 pythia6
ApMon-CPP             GSL                   XRootD                generators            simulation
DDS                   HepMC                 ZeroMQ                glog                  sodium
FairRoot              MPFR                  boost                 lhapdf                xalienfs
"""
    }
  }

develStep: SinglePaneStep
develStep =
  {
    header = """
## Developing O2

What we have done so far is useful if you just plan to simply run
executables provided by O2. In case you want to actually develop O2,
or any of it's dependencies, you actually need to check it out at the same level as
`alidist`.
""",
    pane = ShellPane { shell = """
$ git clone https://github.com/alisw/alibuild
$ git clone https://github.com/alisw/alidist
$ git clone https://github.com/AliceO2Group/AliceO2
$ alibuild build O2
""" }
  }

environmentStep: SinglePaneStep
environmentStep =
  {
    header = """
## Setting up the environment

We now want to set up the environment in order to run O2 executables. In
order to do so an helper script `init.sh` can be used.
""",
    pane = ShellPane {shell = """
$ WORK_DIR=$PWD/sw source sw/osx_x86-64/O2/latest/etc/profile.d/init.sh

$ which testFlp
/Users/me/alice/sw/osx_x86-64/O2/master-1/bin/testFlp
""" }
  }

deviceStep : ImageStep
deviceStep =
  {
    header = """
## Your first device

Let's now try to create a new O2 process which does some sort of
data-processing. O2 describes processing workflows in terms of so called
devices. Devices are instances of the `FairMQDevice` class and they
provide implement computation and communication with other devices.
""",
    image = "device.png"
  }

topologyStep : ImageStep
topologyStep =
  {
    header = """

## Your first device

A group of devices can be linked together in what is called a ``topology''.
""",
    image = "topology.png"
  }

samplerSinkStep : ImageStep
samplerSinkStep =
  {
    header = """

## Your first device

To start with, we will construct a simple topology comprising of two elements:
- a "Sampler" which produces "hello world" objects 
- a "Sink" which consumes them

The source code for this example is at <https://github.com/FairRootGroup/FairRoot/tree/master/examples/MQ/1-sampler-sink>.

""",
    image = "sampler-sink.png"
  }

samplerEnvStep: SinglePaneStep
samplerEnvStep =
  {
    header = """

## Creating the package

In order to create our devices, lets first create a package where we put
all the required sources.

""",
    pane = ShellPane {shell = """
$ cd O2
$ mkdir -p examples/tutorial-1
""" }
  }

samplerHeaderStep: TwoPanesStep
samplerHeaderStep =
  {
    header = """

## Creating the package

We then create the Sampler. At minimum you will need to implement the
Run() method, which is the one which is used to implement the event loop of 
the device state machine.

""",
    leftPane = ShellPane {shell = """
$ cd O2
$ mkdir -p examples/tutorial-1
$ vim examples/tutorial-1/sampler.h
"""},
    rightPane = EditorPane { editor = """
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

#endif /* ALICEO2TUTORIALSAMPLER_H_ */
""",
    filename = "examples/tutorial-1/sampler.h"
    }
  }

samplerImplStep: TwoPanesStep
samplerImplStep =
  {
    header = """

## Creating the package

In the run method you will actually make sure you will keep iterating
until the state machine does not exit from the `RUNNING` state.

In this example we constuct a simple "Hello world" message which we then
publish for subscribers to receive.

Notice the use of the `LOG(INFO)` facility to print out log messages for your
device. 

""",
    leftPane = ShellPane {shell = """
$ vim examples/tutorial-1/sampler.h
"""},
    rightPane = EditorPane {
      filename = "examples/tutorial-1/sampler.cxx",
      editor = """
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
""" 
    }
  }

sinkHeaderStep : TwoPanesStep 
sinkHeaderStep =
  {
    header = """

## Creating the package

Similarly for the Sink, we must derive from `FairMQDevice` and implement the
`Run()` method.

In this case the implementation will simply receive the messages and
print them out.

""",
    leftPane = EditorPane { filename = "examples/tutorial-1/sink.h", editor = """
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
"""},
    rightPane = EditorPane { filename = "examples/tutorial-1/sink.cxx", editor = """
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
"""
    }
  }

applicationsStep: TwoPanesStep 
applicationsStep =
  {
    header = """

## Creating the driver processes

Now that we have our own devices, we need to create some boilerplate to be able to pass them
(optional) arguments and launch them:

""",
    leftPane = EditorPane { filename = "examples/tutorial-1/runSampler.h", editor = """
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
"""},
    rightPane = EditorPane { filename = "examples/tutorial-1/runSink.cxx", editor = """
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
"""
    }
  }

type alias Model = 
  {
    currentStep: Int,
    background: Array Background
  }

model : Model
model = 
  {
    currentStep = 0,
    background = Array.fromList [
      singlePaneBackground welcomeStep,
      singlePaneBackground checkoutStep,
      singlePaneBackground buildStep,
      singlePaneBackground directoryStep, 
      singlePaneBackground environmentStep,
      imageBackground deviceStep,
      imageBackground topologyStep,
      imageBackground samplerSinkStep,
      singlePaneBackground samplerEnvStep,
      twoPanesBackground samplerHeaderStep,
      twoPanesBackground samplerImplStep,
      twoPanesBackground sinkHeaderStep,
      twoPanesBackground applicationsStep
    ]
  }

messages : Signal.Mailbox Action
messages =
    Signal.mailbox NoOp

init : (Model, Effects Action)
init =
  (model, Effects.none)

app : App Model
app = 
    StartApp.start
      { init = init
      , update = update
      , view = view
      , inputs = [ messages.signal,
                   Signal.map Arrows Keyboard.arrows
                 ]
      }

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks

moveToPage : Int -> Model -> Model 
moveToPage page model = 
  { model | currentStep = page }
-- Hash updates simply are used to move from one step to the other.
delta2update : Model -> Model -> Maybe RouteHash.HashUpdate
delta2update old new =
  let
    sameStep = old.currentStep == new.currentStep
  in
    case sameStep of
      False -> Just (RouteHash.set [toString new.currentStep])
      True -> Maybe.Nothing

location2action : List String -> List Action
location2action uriParts =
  case uriParts of
    xs::x -> case (String.toInt xs) of
              Ok i -> [MoveToPage i]
              _ -> [NoOp]
    []  -> [NoOp]

port routeTasks : Signal (Task () ())
port routeTasks =
    RouteHash.start
        { prefix = RouteHash.defaultPrefix
        , address = messages.address
        , models = app.model
        , delta2update = delta2update
        , location2action = location2action
        }

currentBackground : Model -> Html
currentBackground model = 
  let
    maybeBackground = get model.currentStep model.background
  in
    case maybeBackground of
      Just background -> div [] [ background.template ]
      Maybe.Nothing -> div [] [text "Error"]

stepKind : Int -> Model -> Attribute
stepKind n model =
  if n == 0 then
    completeStep
  else if n > model.currentStep then
    incompleteStep
  else
    completeStep
    
stepper : Model -> Html
stepper model =
  let
    numberOfSlides = Array.length(model.background)
    navigationButton = (\n -> li [stepStyle] [a [href ("#" ++ (toString n)), stepKind n model] [text (toString n)]]) 
  in
    ol [stepperStyle] (List.map navigationButton [0 .. numberOfSlides-1])
 
view address model =
  div []
    [ 
      div [topBarStyle] [stepper model],
      div [descriptionStyle] [currentBackground model]
    ]

type Action = NoOp 
            | MoveToPage Int
            | Arrows { x : Int, y : Int }

handleArrows : Model -> { x : Int, y : Int } -> Model
handleArrows model a =
  let
    nextPage = model.currentStep + a.x
    lastPage = (Array.length model.background) - 1
    page = if nextPage < 0 then
             0
           else if nextPage >= lastPage then
             lastPage
           else
             nextPage
  in
    moveToPage page model

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, Effects.none)
    MoveToPage page -> (moveToPage page model, Effects.none)
    Arrows a -> (handleArrows model a, Effects.none)

port currentPage : Signal Int
port currentPage = Signal.map (\n -> 1) messages.signal
