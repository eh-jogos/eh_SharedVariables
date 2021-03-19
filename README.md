# eh_SharedVariables

Godot Plugin to add SharedVariables to your project.

Shared Variables are my attempt to do something similiar to the system Ryan Hipple describes in his Unite 2017 talk, of using ScriptableObjects as a game architecture, and in Godot's case, using Custom Resources. Godot's Resources are a pretty good fit for it and even simplify the process a bit, though making it work in the editor smoothly is a bit more convoluted.

The system here brings some often used default types as "SharedVariables", custom reources you can use in place of these default types whenever it is advantageous for some property to be shared between multiple systems in the game. So for example, you can use a FloatVariable instead of a float to track you players HP value, and whenever it takes damages or heal, the Health Bar in the UI will react automatically because it is using the same FloatVariable in it. You may check this in action in the Demo Scene that's int this repository.

This addon also comes with some tools and helpers to automate showing the SharedVariables in the inspector, while maintaining typed references in the code even though they are CustomResources which usually can only be exported as generic Resource.

Useful links:
- [Ryan's Talk](https://www.youtube.com/watch?v=raQ3iHhE_Kk)
- [Ryan's Article](https://unity.com/how-to/architect-game-code-scriptable-objects)
- Heartbeast tutorial for CustomResources in Godot: [part 1](https://www.youtube.com/watch?v=wuxal3C0800) [part 2](https://www.youtube.com/watch?v=nkMj4Is81zs)

## License
This is Licensed under MIT as you and see in the LICENSE file, so use it however you want, in any comercial projects or not, just link this repository or this readme in the credits or somewhere.

## Support
If you like this project and want to support it, any improvements pull request is welcomed!

Or if you prefer, you can also send a tip through [ko-fi](https://ko-fi.com/eh_jogos) or take a look at my [patreon](https://www.patreon.com/eh_jogos)!
