# Lindenmayer Playground

Inspired by the [Mandelbrot playground](https://developer.apple.com/swift/blog/?id=26) released by the Swift development team, this playground features [Lindenmayer systems](http://en.wikipedia.org/wiki/L-system), better known as L-Systems.

According to Wikipedia, *An L-system or Lindenmayer system is a parallel rewriting system and a type of formal grammar.* In this playground you can try out rendering various predefined systems or define your own. The Lindenmayer struct used to define a rule set allows for the basic operators, drawing, moving, turning and grouping.

For more information, look at the sources attached to the main playground. 
All examples of systems come from Wikipedia.

Author: Henri Normak - [@henrinormak](https://twitter.com/henrinormak)

## Future work

It might be interesting to expand this to include stochastic rules and make it more applicable for rendering trees and plants as described in [The Algorithmic Beauty of Plants](http://algorithmicbotany.org/papers/abop/abop.pdf). It would also be cool to have a way of evaluating expressions within replacement rules, such as "Move forward 0.2 of previous unit size". Similarly, it would also be interesting to allow more customisation in terms of colours of specific lines etc, not only would that allow more interesting visualisation, it would also help people understand how the rules are evaluated.
