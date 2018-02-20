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
- **Controller**: The `BubbleArenaController` is the main controller for the game view. To support `bubbleArena` which is a `UICollectionView`, this class will conform to `UICollectionViewDataSource`, `UICollectionViewDelegate` and `UICollectionViewDelegateFlowLayout` protocols. The `BubbleLauncherController` controls the related operations and user input about launching a bubble (using the bubble launcher at the middle bottom of the screen). After a bubble has been launched, the `ShootingBubbleController` will take over the control. It will work closely with `PhysicsEngine` and `GameObjectsController` to instruct the movement of shooted bubbles and detect collision. Whenver collision happens, the `PhysicsEngine` will inform `ShootingBubbleController` to handle the game-specific logic. `GameObjectsController` acts as a bridge and mapping between the `GameObject`s managed in the game engine and `FilledBubble`s stored in the model. For information passing and notification of events happened, delegate pattern is applied to the three main controllers. They conform to `BubbleArenaControllerDelegate`, `BubbleLauncherControllerDelegate` and `ShootingBubbleControllerDelegate` protocols respectively.
- **View**: The view in this problem set is pretty simple. It mainly consists of two parts, the `BubbleArena` and the `BubbleLauncher`. The `BubbleArena` is a `UICollectionView`, which is composed of many `BubbleCell`s, which conforms to the `UICollectionViewCell` protocol. The `BubbleLauncher` is simply a `UIImageVIew`, which shows the next bubble to be launched. Whenever the player shoots a bubble, it will be updated according to the supply from `BubbleProvider`.

_(The idea of rigid body & collision is adapted from [Unity3D game engine](https://docs.unity3d.com/2018.1/Documentation/ScriptReference/Rigidbody.html), although there are variations.)_

## Problem 1.2

Thanks to the flexible nature of the current design, more complex game logic can be supported easily. Notice that such kind of game logic is specific to this game. Thus, they should not be part of the game engine. Instead, they should be triggered when the `PhysicsEngine` notifies the `ShootingBubbleController` that a collision happens. When the `ShootingController` gets notified that a collision happens, it should show different behaviors according to the `BubbleType` of two parties of the collision.

If the `BubbleType` is just the normal colors, the behavior would be the same as the current one. If it is a special type, some special behaviors will be triggered. To support removal of all bubbles of a specific color, we just need to check whether the shooted bubble collides with this special type of `FilledBubble`. If so, we will let the model, the `Level` object finds all the `FilledBubble`s with the same color. After that, we will delete these bubbles from the model, reload these cells in the collection view, deregister the corresponding `GameObject`s from the physics engine (and also apply effects like _fading-away_).

## Problem 2.1

In the current design, the user can specify the angle to launch the bubble by single-tap on any position of the screen. However, notice that the single-tap must happen at which is at least slightly higher than the `BubbleLauncher` (because we only allow the user to launch bubbles upwards). After that, the position of the single-tap gesture will be computed relative to the position of the `BubbleLauncher`. After that, the angle will be calculated using `θ = atan(dy/dx)`. If `dy < 0` (which means the angle will be negative and the bubble will be shooted downwards), the input will not be accepted.

Then, we will create a `GameObject` whose intial position will be the same as `BubbleLauncher`. The magnitude of its speed will be a constant, while the angle changes according to the user input. This `GameObject` will be registered into the `PhysicsEngine`, which will in turn handle its movement and collision afterwards.

In the meantime, the `BubbleLauncher` will also be updated by asking `BubbleProvider` to supply it with the next randomly-generated bubble ready for launch.

## Problem 3: Testing

The strategy for testing this application is stated as follows:

#### Black-box testing

- Test the launch of a bubble
    - When I single-tap on a location of the screen that is not at least slighlt higher than the position of the bubble launcher, I expect the input is rejected and nothing will happen.
    - When I already have a shooted bubble travelling (collision not happened yet), I expect the input is rejected and nothing will happen.
    - Otherwise, I expect the bubble is launched in the direction towards the point of the single-tap gesture.
- Test the movement of a bubble
    - When a bubble has been launched (shooted) successfully, I expect the travelling speed to be a positive constant. I also expect the bubble travels in a staight line (as long as no collision with screen edge or other bubbles happen).
    - When a bubble is falling down, I expect it to be a free falling process (without the effect of air resistance), i.e., its acceleration is a positive constant. Visually, the velocity should increase. I also expect the falling down in straight downwards.
- Test collision between two bubbles
    - When a shooted bubble collides with a remaining static bubble, I expect the shooted bubble to stop moving and snap to the nearest empty cell.
    - Following above, when there are more than 3 connected bubbles of the same color, I expect them to be removed with a fading away effect.
    - Following above, when there are bubbles unattached to the top wall, I expect them to be removed by falling down out of the screen.
    - When a shooted bubble "collides" with a falling bubble, I expect no collision will happen and they will bypass each other.
- Test collision between a bubble and a screen edge
    - When a shooted bubble collides with the side wall (left or right), I expect a reflection happens. In other words, the (horizontal component of the) moving direction of the bubble should reverse.
    - When a shooted bubble collides with the top wall, I expect it to stop moving and snap to the nearest empty cell.
    - Following above, after snapping to the nearest empty cell, normal behavior should happen if it collides with any other static bubble.

#### Glass-box testing
- `BubbleArenaController`:
    - `viewDidLoad`: Correctly set the delegate and data source of the collection view. Also properly initialize and set the delegate for `BubbleLauncherController` and `ShootingBubbleController`.
    - `handleBubbleLaunch`: Should call the `BubbleLauncherController`. We can use a stub to test this.
    - `collectionView(_ collectionView: , layout collectionViewLayout: , sizeForItemAt indexPath: )`: The even rows should exactly match the width of screen.
    - `collectionView(_ collectionView: , layout collectionViewLayout: , insetForSectionAt section: )`: All bubble cells should be tightly packed.
    - `numberOfSections`: To define the collection view to have 12 sections.
    - `collectionView(_ collectionView: , numberOfItemsInSection section: )`: 12 items on even rows, 11 items on odd rows.
    - `collectionView(_ collectionView: , cellForItemAt indexPath: )`: Each cell can be either empty (transparanet) or shown with a certain colored background image.
- `BubbleArenaControllerDelegate`:
    - `addMovingBubble`: I expect the resulting `UIImageView` is using the background image corresponding to the provided type. I also expect the center of the result bubble should be on the point passed in.
- `BubbleLauncherController`:
    - `init`: Create a controller with a `UIButton` passed in.
    - `handleBubbleLaunch`: We can use a stub to act as the delegate for `ShootingBubbleController`.
        - If the point passed in has a y-coordinate not above the y-coordinate of `UIButton` passed in `init` with a difference of `Settings.launchVerticalLimit`, I expect the `addShootedBubble` in the stub not being called.
        - Otherwise, I expect the `addShootedBubble` in the stub to be called.
        - Following above, If i call `handleBubbleLaunch` again, no matter the y-coordinate of the point passed in, I expect the `addShootedBubble` in the stub not being called. I also expect the angle derived from the `GameObject`'s speed vector is corresponded to the passed in angle.
        - Repeat above by initializing a new `BubbleLauncherController` object, I expect the type passed into `addShootedBubble` is random.
- `ShootingBubbleController`: Similarly, we need to use stubs to act as the delegate for `BubbleArenaController` and `BubbleLauncherController`.
    - `init`: Create a controller with a `UICollectionView` and `Level` passed in.
    - `handleCollision`:
        - When the `GameObject` passed in is at an invalid location (defined by `level`), I expect the `markReadyForNextLaunch` should be called but nothing else will happen.
        - When the passed in `level` is empty, I expect the `level` to be added a `FilledBubble` at the nearest empty cell. And I expect the type of this filled bubble to be the same as the one when I initialize the `GameObject`.
        - When the passed in `level` is not empty but the number of connected bubbles with the same color is smaller than 3, the same as above should happen.
        - When the passed in `level` is not empty and the number of connected bubbles with the same color is more than or equal to 3, these bubbles should be removed from the `level`.
        - Following above, if there are unattached bubbles after those same-color bubbles are removed, they will also be removed.
- `PhysicsEngine`: Use stub as a delegate for `ShootingBubbleController`.
    - `init`: Create a physics engine.
    - `registerGameObject`:
        - When I register a `GameObject` without setting its speed/acceleration (initial values are both 0), the position and velocity of the `GameObject` should not change.
        - When I register a `GameObject` with non-zero speed or acceleration, I should expect the position of the `view` in `GameObject` to change according to its speeed & acceleration.
    - `deregisterGameObject`:
        - When the provided `GameObject` has not been registered with the `PhysicsEngine` before, I expect nothing should happen.
        - When the provided `GameObject` was registered with the `PhysicsEngine` before but speed & acceleration are both 0, I expect nothing should happen as well (because it does not move anyway).
        - When the provided `GameObject` was registered before and speed & acceleration may be non-zero, I expect the speed & acceleration will remain its value from now on.
    - `removeGameObject`:
        - When the provided `GameObject` has not been registered with the `PhysicsEngine` before, I expect nothing should happen.
        - When the provided `GameObject` was registered with the `PhysicsEngine` before but speed & acceleration are both 0, I expect nothing should happen as well (because it does not move anyway).
        - When the provided `GameObject` was registered before and speed & acceleration may be non-zero, I expect the speed & acceleration will remain 0 from now on.
- `GameObjectController`:
    - `addShootedBubble` and `addRemainingBubble`: Should be tested by/with the other two methods.
    - `popShootedBubble` and `popRemainingBubble`:
        - When the `GameObject` has been added before, I expect the original `FilledBubble` or `BubbleType` to be returned.
        - When the `GameObject` has not been added before, I expect `nil` to be returned.
- `GameObject`:
    - `move`: I expect its position/speed to change by a unit (as long as its speed/acceleration is not 0).
    - `stop`: I expect its acceleration & speed both become 0.
    - `brake`: I expect its speed become 0, while acceleration remains unchanged.
    - `reflectX`: I expect the x-component of its speed vector to reverse.
    - `reflectY`: I expect the y-component of its speed vector to reverse.
    - `isStatic`: I expect it to be true if acceleration & speed are both 0; false otherwise.
- `Level`:
    - `init`: Checks the `numOfRows`, `evenCount`, `oddCount` after initiaization.
    - `addOrUpdateBubble`:
        - The added bubble is at a valid location.
        - The added bubble is at an invalid location.
    - `hasBubble` and `hasBubbleAt`:
        - The location is valid and the bubble exists.
        - The location is valid but the bubble does not exist.
        - The location is invalid.
    - `getBubbleAt`:
        - The location is valid and the bubble exists.
        - The location is valid but the bubble does not exist.
        - The location is invalid.
    - `deleteBubble` and `deleteBubbleAt`:
        - The location is valid and the bubble exists.
        - The location is valid but the bubble does not exist.
        - The location is invalid.
- `FilledBubble`:
    - `init`: I expect the row, column & type to be correct after initialization.
    - `==`: When row, column & type are all the same, I expect the result is true; otherwise false.
- `BubbleType`:
    - `nextColor`: For each case, check whether the next color is correct.
- `BubbleProvider`:
    - `peek`: No matter how many times I call this method, I expect the answer to be always the same; unless I re-initialize it.
    - `pop`: Each time I call this method, I expect the return value to be randomly generated and may not be the same as the previous one.
- `BubbleCell`:
    - `init`: I expect its `cornerRadius` equal to half of its length.
    - `fill`: I expect the `UIImage` passed in become a subview of its `contentView`.
    - `clear`: I expect its image in `contentView` disappear.
