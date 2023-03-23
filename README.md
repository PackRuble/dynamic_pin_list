# dynamic_pin_list

Use this repository as a starting point for setting up control
dynamic pining of items in the list (`CustomScrollView`)

Customize the animation of the docking widget at the bottom of the list to your liking.

Related question: [How do I dynamically anchor an item at the top or bottom of a list?](https://stackoverflow.com/questions/75745750/how-do-i-dynamically-anchor-an-item-at-the-top-or-bottom-of-a-list/75821040#75821040)

To run this example, clone the repository on your machine and use the command:

```dart
flutter run
```

## Feature

The selected item can be anchored both at the bottom and at the top of the list, depending on its current position in the list.

![dynamic_pin_1.gif](res/dynamic_pin_1.gif)

| Dependencies                                                        |
|---------------------------------------------------------------------|
| [flutter_hooks](https://pub.dev/packages/flutter_hooks)             |
| [visibility_detector](https://pub.dev/packages/visibility_detector) |
| [sliver_tools](https://pub.dev/packages/sliver_tools)               |

