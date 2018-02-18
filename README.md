CS3217 Problem Set 4
==

**Name:** Niu Yunpeng

**Matric No:** A0162492A

**Tutor:** Louie Tan

## Tips

1. CS3217's Gitbook is at https://www.gitbook.com/book/cs3217/problem-sets/details. Do visit the Gitbook often, as it contains all things relevant to CS3217. You can also ask questions related to CS3217 there.
2. Take a look at `.gitignore`. It contains rules that ignores the changes in certain files when committing an Xcode project to revision control. (This is taken from https://github.com/github/gitignore/blob/master/Swift.gitignore).
3. A SwiftLint configuration file is provided for you. It is recommended for you to use SwiftLint and follow this configuration. Keep in mind that, ultimately, this tool is only a guideline; some exceptions may be made as long as code quality is not compromised.
    - Unlike previous problem sets, you are creating the Xcode project this time, which means you will need to copy the config into the folder created by Xcode and [configure Xcode](https://github.com/realm/SwiftLint#xcode) yourself if you want to use SwiftLint. 
4. Do not burn out. Have fun!

## Problem 1: Design

## Problem 1.1

![Class Diagram](class-diagram.png)

_(Credit to [ProcessOn](https://www.processon.com/) for providing us with an excellent online tool to draw UML diagram)_

This `Bubble Hero Engine` application follows the MVC (_model, view, controller_) architecture. Each component is explained as follows:
- **Model**: The model provides a reliable backend store for all the data in the game. Similar to Problem Set 3, a `Level` is composed of
many `Bubble`s. By default, each `Level` has 12 rows, 11/12 columns of `FilledBubble`s. However, note that the `Level` class this type supports more functionalities compared to Problem Set 3. `Stack` is used to support some of these functionalities internally. In Problem Set 5, we may create subclasses for `FilledBubble` since there are special bubbles. Each `FilledBubble` has a `BubbleType`. For example, `FilledBubble`s of different colors are of different `BubbleType`s. Each object controlled by the `PhysicsEngine` must be a `GameObject`. A `GameObject` represents a simplified idealized physical object that obeys a certain subset of physics laws. In this problem set, it is a 2D object with no mass or volumn. However, it has a fixed size and its shape is a perfect circle. If its `isRigidBody` attribute is `true`, then it becomes a rigid body. Collision may happen between two rigid bodies. A `GameObject` can have speed and acceleration, both of which can be seen as a 2D vector. The `BubbleProvider` will continously generate random `BubbleType`, as a supplier for the bubble launcher.
- **Controller**: The `ViewController` is the main controller for the game view. Since `bubbleArena` is a `UICollectionView`, this class will conform to `UICollectionViewDataSource`, `UICollectionViewDelegate` and `UICollectionViewDelegateFlowLayout` protocols. Also, it conforms to `ControllerDelegate` protocol so that we can apply delegate pattern in the `PhysicsEngine` class. The `PhysicsEngine` handles the movement of all `GameObject`s and detect collision between rigid bodies. When collision happens, it will call the `ViewController` delegate to further handle it (because such logic is specific to this bubble blast game, which should not be part of a generic game engine). The `PhysicsEngine` will also play the role of a renderer. It will update the position of all `GameObject` per frame refreshed by `CADisplayLink` (to show their movement). `GameObjectController` acts like a bridge between `ViewController` and `PhysicsEngine`. It is like a mapping between `FilledBubble`s (or shooted bubbles, falling bubbles) and their `GameObject` representation in the `PhysicsEngine`.
- **View**: The view in this problem set is pretty simple. It mainly consists of two parts, the `BubbleArena` and the `BubbleLauncher`. The `BubbleArena` is a `UICollectionView`, which is composed of many `BubbleCells`, which conforms to the `UICollectionViewCell` protocol. The `BubbleLauncher` is simply a `UIImageVIew`, which shows the next bubble to be launched. Whenever the player shoots a bubble, it will be updated according to the supply from `BubbleProvider`.

_(The idea of rigid body & collision is adapted from [Unity3D game engine](https://unity3d.com/).)_

## Problem 1.2

Your answer here

## Problem 2.1

Your answer here

## Problem 3: Testing

Your answer here
