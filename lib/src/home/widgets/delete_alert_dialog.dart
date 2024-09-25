import 'package:flutter/material.dart' show Colors, showDialog;
import 'package:flutter/widgets.dart'
    show BuildContext, Navigator, Offset, Positioned, RenderBox, Stack, Text;
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'
    show PlatformAlertDialog, PlatformDialogAction, showPlatformDialog;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/particle_effect.dart'
    show ParticleEffect;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;

Future showAlertBeforDeleting(
    BuildContext context, TodoProvider todoProvider, int index) async {
  showPlatformDialog(
    context: context,
    builder: (_) => PlatformAlertDialog(
      title: Text(
        "Deleting Todo?",
        style: sfTextTheme.titleLarge,
      ),
      content: Text(
        "Are you sure you want to delete this Todo?",
        style: sfTextTheme.bodyLarge,
      ),
      actions: [
        PlatformDialogAction(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'Cancel',
            style: sfTextTheme.labelLarge,
          ),
        ),
        PlatformDialogAction(
          onPressed: () {
            Navigator.of(context).pop(true);
            if (context.mounted) {
              final todoName = todoProvider.dailyToDolist[index].title;
              todoProvider.deleteTodo(index, context);
              _showParticleEffect(todoName, context);
            }
          },
          child: Text(
            'Delete',
            style: sfTextTheme.labelLarge,
          ),
        ),
      ],
    ),
  );
}

void _showParticleEffect(String todo, BuildContext context) {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero);
  final size = renderBox.size;

// The reason we choose to do Particle effect in a diglog
// so that it doesn't effect the current layout of the List view
// And we get our animation effect smoothly

  showDialog(
    context: context,
    barrierColor: Colors.transparent, // Dialog goes full screen
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: ParticleEffect(
              text: todo,
              width: size.width,
              height: size.height,
              onComplete: () {
                if (context.mounted) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ),
        ],
      );
    },
  );
}
