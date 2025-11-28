## Infinite hexagons

This is an experiment to create a virtually infinite scrolling hexagon grid. It is still technically finite, but it's big enough that most people would not notice.

I used a UIScrollView to get all of the iOS scrolling interactions for free, then position the SwiftUI View so that it is always positioned to match the frame of the UIScrollView. This allows using manual contentSize and offset options that are not available in SwiftUI.

Then the ScrollViewport information is given to the SwiftUI content view so it can render the appropriate hexagons. This allows only creating the hexagons which are currently visible.

When scrolling gets too fast the rendering can't quite keep up, but it doesn't stutter or lag. 

Some of the hexagon code is a bit of an AI mess, but it gets the job done.

![](hexagons.mov)
