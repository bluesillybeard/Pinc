# The Pinc documentation

First off - functions and types are documented in the header itself. Look there for documentation of that kind.
This documentation is for the more general Pinc topics

## Handles
All (ALL) Pinc objects are managed through object handles - Similar to something like OpenGL. A handle is ultimately just a number ID to that object, however the ID does not have any type information at runtime. It is not possible to determine what kind of object and ID corresponds to at runtime. For this reason, the header provides typedefs for all different types of IDS that exist.

## Object completion
Due to Pinc's focus on being easy to port to other languages, no API functions are allowed to take structs larger than a few members. This means, a function that creates an object must either have all properties in the init function as parameters, or use more function calls.

Using more function calls in Pinc is straightforward. First, call a function called "pinc_[type]_incomplete_create", which will create an incomplete version. That function will take all values that do not have defaults. Then, functions labeled "pinc_[type]\_set\_[parameter]" can be used to set any optional values of that object. Finally, call "pinc_[type]_complete" which will actually create the object that can be used. Each individual set function will document whether it can be used on objects that are incomplete, complete, or either.

## Unimplemented functions
As pinc is a new library, many functions will not be implemeted. Functions that are not implemented are not exported, so a link error will occur if you try to use them. Whether a function is implemented can be target specific. Some functions are partially implemented, and (for the time being) will crash the program if an unimplemented part of a function is called. Eventually, I plan on having all functions implemented in all backends, but for now you'll have to be weary of them.

Note that not all unimplemented functions will cause link errors at compile time, so it's still worth testing the application by running it (which you should be doing anyway!)

the SDL backend is the one with the fewest unimplemented functions - which is why Pinc will use SDL by default instead of the raw backend.
