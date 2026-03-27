# 🌻 Fullflower Homework!

### Code Structure
* Services & Controllers - These are modules that provide functionality not related to physical instances. For examples; Data, Coins, CollisionGroups, etc. Services are the server-side name while controllers are the clien-side name.
* Managers - These modules provide functionality for instances and are themselves an instance! They use Sleitnicks Observers library with attributes to provide an "instance" based source of truth! Making it much easier to handle the lifecycle of an instance and react to state changes!
* Behaviors - These modules provide functionality for instances, but they themselves are NOT an instance. Think traits, examples include; Interactablity, Carrying, etc. We make this object "interactable" for example. Structure is very similar to Managers.
* Types - Just my types! I love myself some static typing, sometimes I go overboard though. But the autocomplete is just too nice.
* Configurations - Data-oriented configurations! Allowing for easy changing of fundamental game features, but additionally the ability to use Roblox's cloud configs very easily. In this game they are used for Furniture and Seller data.
* Packages - A handful of Packages that I commonly use for development. I personally prefer a handful of lightweight packages over a large framework, but I have used both before and each has their own pros and cons!

ReplicatedStorage contains not only shared code, but additionally the client code. ServerScriptService contains all of the server code.

### Assumptions
I don't think I made many of these. I suppose I assumed we wanted a nice on screen UI for the coins, and models that look different whether they are ditry or clean.

Maybe another assumption might be that the Engineering team has experience using open source tooling like RbxUtils by Sleitnick for example.

### Improvements
* Cleaning up the server side of SellerManager. I don't really like the implementation for state or price determination.
* Cleaning up the SellerConfiguration, I like the idea of accepting functions or strings, but limiting the function to specifically "Price" restricted the actual implementation.
* Sound effects for sure! Would love to add those!
* I would love it if the NPC waved at you as you walked by.
* Neat UI effects when you earned coins.
* Expanding on the state machine with the NPC to include actual dialog and selectable options.
