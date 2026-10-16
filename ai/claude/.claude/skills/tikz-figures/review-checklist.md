# Physics and logic review

Ask each question of the picture. Answer pass or fail with one reason. Any fail means fix and rebuild.

## Every figure
- Does each label name the thing it touches?
- Do symbols and units match the topic (for example `z` is distance, `t` is time)?
- Could a student misread any arrow, line or colour? Is there a legend or label for it?

## Label placement (reason about every label)
For each text label, answer in one line each:
1. Which object does it name?
2. Where is it: which side, how far in mm, centred on the object or on its guide line?
3. Is another object nearer? Could a reader attach the label to that one?
4. Does a line, border, arrow or other text touch it?

A label passes when the named object is the nearest one, nothing touches the text, and the gap is 1 to 4 mm. State the reason for each pass or fail. Never write "looks fine".
- `label-check` finds lines through words and overlapping words. It does not judge nearness. Judge nearness yourself.
- A long label that reaches other labels needs its own row and a guide line to its object.

## Block diagrams
- Do arrows follow the data flow from input to output?
- Does each arrow label match the output of the box before it?
- Is every box reached by one input arrow and left by one output arrow, unless it is a start or an end?
- Does every arrow carry a signal label, or end at a named output? Does a label match the data the box before it produces?

## Optics
- Does the beam radius stay continuous at the lens? A slope change is correct.
- Does a converging lens make the beam narrow toward a waist, and a diverging beam widen away from it?
- Is the waist where the distance labels say it is?
- Are distances to the right of the lens measured from the lens?
- Is the waist marked inside the beam, with its radius?
- Does a label say where each beam parameter applies (just before or just after the lens)?

## Plots
- Do curves start and end at values the physics gives (for example a step response settles at 1)?
- Does only the underdamped case overshoot? Does the order of curves match the parameter?
- Are axis labels, units and limits readable and complete? Does a curve leave the plot area?

## Mechanics
- Does each spring and damper join two bodies?
- Does the mass lag the case? It moves opposite to the case acceleration. Is that the way the arrows point?
- Do dotted or dashed marker lines say what they mark (centre, edge, rest)?
- Does hatching mean fixed to the ground? A moving body must not be hatched.
- Is displacement measured from a marked rest position?
- Does the input arrow touch the body it acts on?
