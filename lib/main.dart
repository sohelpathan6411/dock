import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock<IconData>(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T extends IconData> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T extends IconData> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  /// Index of the dragged item.
  int? draggedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black45,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          _items.length,
          (index) {
            final item = _items[index];

            return Draggable<int>(
              data: index,
              feedback: Material(
                color: Colors.transparent,
                child: Icon(
                  item,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.4,
                child: Icon(
                  item,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              onDragStarted: () {
                setState(() {
                  draggedIndex = index;
                });
              },
              onDragEnd: (details) {
                setState(() {
                  draggedIndex = null;
                });
              },
              child: DragTarget<int>(
                onAcceptWithDetails: (details) {
                  setState(() {
                    // Swap the icons using the details provided by the drag event
                    final draggedItem = _items[details.data];
                    _items[details.data] = _items[index];
                    _items[index] = draggedItem;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(10),
                    transform: draggedIndex == index
                        ? (Matrix4.identity()..translate(0.0, -20.0))
                        : Matrix4.identity(),
                    child: Icon(
                      item,
                      size: 50,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}