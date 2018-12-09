# Bubble Hero Engine

This is the game engine for the iOS game [Bubble Hero](https://github.com/yunpengn/BubbleHero), built with Swift 4 and latest API from iOS 11. It was built by [Yunpeng](https://yunpengn.github.io/) in 2018.

This engine is published as a [Cocoapod](https://cocoapods.org). Add the following line to your `Podfile` for usage:
```ruby
pod 'GameEngine', :git => 'git@github.com:yunpengn/BubbleHeroEngine.git', :branch => 'master'
```

## Design & Class Diagram

![Class Diagram](class-diagram.png)

_(Credit to [ProcessOn](https://www.processon.com/) for providing us with an excellent online tool to draw UML diagram)_

This `Bubble Hero Engine` application follows the MVC (_model, view, controller_) architecture. Each component is explained as follows:
- **Model**: The model provides a reliable backend store for all the data in the game. Similar to Problem Set 3, a `Level` is composed of
many `Bubble`s. By default, each `Level` has 12 rows, 11/12 columns of `FilledBubble`s. However, note that the `Level` class this type supports more functionalities compared to Problem Set 3. `Stack` is used to support some of these functionalities internally. In Problem Set 5, we may create subclasses for `FilledBubble` since there are special bubbles. Each `FilledBubble` has a `BubbleType`. For example, `FilledBubble`s of different colors are of different `BubbleType`s. Each object controlled by the `PhysicsEngine` must be a `GameObject`. A `GameObject` represents a simplified idealized physical object that obeys a certain subset of physics laws. In this problem set, it is a 2D object with no mass or volumn. However, it has a fixed size and its shape is a perfect circle. If its `isRigidBody` attribute is `true`, then it becomes a rigid body. Collision may happen between two rigid bodies. A `GameObject` can have speed and acceleration, both of which can be seen as a 2D vector. The `BubbleProvider` will continously generate random `BubbleType`, as a supplier for the bubble launcher.
- **Controller**: The `BubbleArenaController` is the main controller for the game view. To support `bubbleArena` which is a `UICollectionView`, this class will conform to `UICollectionViewDataSource`, `UICollectionViewDelegate` and `UICollectionViewDelegateFlowLayout` protocols. The `BubbleLauncherController` controls the related operations and user input about launching a bubble (using the bubble launcher at the middle bottom of the screen). After a bubble has been launched, the `ShootingBubbleController` will take over the control. It will work closely with `PhysicsEngine` and `GameObjectsController` to instruct the movement of shooted bubbles and detect collision. Whenver collision happens, the `PhysicsEngine` will inform `ShootingBubbleController` to handle the game-specific logic. `GameObjectsController` acts as a bridge and mapping between the `GameObject`s managed in the game engine and `FilledBubble`s stored in the model. For information passing and notification of events happened, delegate pattern is applied to the three main controllers. They conform to `BubbleArenaControllerDelegate`, `BubbleLauncherControllerDelegate` and `ShootingBubbleControllerDelegate` protocols respectively.
- **View**: The view in this problem set is pretty simple. It mainly consists of two parts, the `BubbleArena` and the `BubbleLauncher`. The `BubbleArena` is a `UICollectionView`, which is composed of many `BubbleCell`s, which conforms to the `UICollectionViewCell` protocol. The `BubbleLauncher` is simply a `UIImageVIew`, which shows the next bubble to be launched. Whenever the player shoots a bubble, it will be updated according to the supply from `BubbleProvider`.

_(The idea of rigid body & collision is adapted from [Unity3D game engine](https://docs.unity3d.com/2018.1/Documentation/ScriptReference/Rigidbody.html), although there are variations.)_

## Acknowledgements

We would like appreciate the wonderful resources provided by the following websites:
- Flat Icons [https://www.flaticon.com]
- Pexels [https://www.pexels.com]
- ProcessOn [https://www.processon.com/]
- Unity3D Game Engine [https://unity3d.com/]

## Licence

[GNU General Public Licence 3.0](LICENSE)
