//: # Lindenmayer Systems Playground
//:
//: Inspired by the [Mandelbrot playground](https://developer.apple.com/swift/blog/?id=26) released by the Swift development team, this playground features [Lindenmayer systems](http://en.wikipedia.org/wiki/L-system), better known as L-Systems.
//:
//: According to Wikipedia, *An L-system or Lindenmayer system is a parallel rewriting system and a type of formal grammar.* In this playground you can try out rendering various predefined systems or define your own. The Lindenmayer struct used to define a rule set allows for the basic operators, drawing, moving, turning and grouping.
//:
//: For more information, look at the sources attached to this playground. All examples of systems come from Wikipedia.
//:
//: Author: Henri Normak - [@henrinormak](https://twitter.com/henrinormak)
//:

import UIKit

//: The code is split into two files, a view that can render a set of rules constructed from an L-System
//: And a struct defining the system itself, which can be expanded into an array of rules for a given amount of generations
let view = LindenmayerView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
view.strokeWidth = 1

//: ## Sierpinski triangle
let sierpinski = Lindenmayer(start: "A",
                             rules: ["A": "B-A-B",
                                     "B": "A+B+A"],
                             variables: ["A": .draw,
                                        "B": .draw,
                                        "+": .turn(.left, 60),
                                        "-": .turn(.right, 60)])

view.initialState = LindenmayerView.State(0, CGPoint(x: 0, y: 0))
view.rules = sierpinski.expand(8)

//: ## Fractal plant
let plant = Lindenmayer(start: "X",
                        rules: ["X": "F-[[X]+X]+F[+FX]-X",
                                "F" : "FF"],
                        variables: ["F": .draw,
                                    "X": .ignore,
                                    "-": .turn(.left, 25),
                                    "+": .turn(.right, 25)])

view.initialState = LindenmayerView.State(-90, CGPoint(x: 0, y: 0))
view.rules = plant.expand(6)

//: ## Dragon curve
let dragonCurve = Lindenmayer(start: "FX",
                              rules: ["X": "X+YF+", "Y": "-FX-Y"],
                              variables: ["X": .ignore, "Y": .ignore,
                                          "F": .draw,
                                          "-": .turn(.left, 90),
                                          "+": .turn(.right, 90)])

view.rules = dragonCurve.expand(10)

//: ## Pythagoras Tree
let pythagoras = Lindenmayer(start: "0",
                             rules: ["1": "11", "0": "1[-0]+0"],
                             variables: ["1": .draw, "0": .draw, "-": .turn(.left, 45), "+": .turn(.right, 45)])

view.rules = pythagoras.expand(10)

//: ## Koch curve
let koch = Lindenmayer(start: "F",
                        rules: ["F": "F+F-F-F+F"],
                        variables: ["F" : .draw, "+": .turn(.left, 90), "-": .turn(.right, 90)])

view.initialState = LindenmayerView.State(0, CGPoint(x: 0, y: 0))
view.rules = koch.expand(4)

