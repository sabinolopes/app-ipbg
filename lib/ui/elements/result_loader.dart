import 'package:app_igreja_guacui/shared/result.dart';
import 'package:app_igreja_guacui/ui/elements/loading_indicator.dart';
import 'package:app_igreja_guacui/ui/elements/message_with_action.dart';
import 'package:flutter/material.dart';

/// Runs [load] and shows the loading state, the error with a retry button or
/// the content built from the loaded data.
class ResultLoader<Data> extends StatefulWidget {
  const ResultLoader({
    required this.load,
    required this.loadingLabel,
    required this.builder,
    super.key,
  });

  final Future<Result<Data>> Function() load;
  final String loadingLabel;
  final Widget Function(Data data) builder;

  @override
  State<ResultLoader<Data>> createState() => _ResultLoaderState<Data>();
}

class _ResultLoaderState<Data> extends State<ResultLoader<Data>> {
  late Future<Result<Data>> _loading;

  @override
  void initState() {
    super.initState();
    _loading = widget.load();
  }

  void _retry() {
    setState(() {
      _loading = widget.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loading,
      builder: (context, snapshot) {
        // On retry, FutureBuilder keeps the previous result until the new
        // one arrives; without this the old error would stay on screen.
        final isDone = snapshot.connectionState == ConnectionState.done;
        return _content(isDone ? snapshot.data : null);
      },
    );
  }

  Widget _content(Result<Data>? result) {
    return switch (result) {
      null => LoadingIndicator(label: widget.loadingLabel),
      Success(:final data) => widget.builder(data),
      Failure(:final message) => MessageWithAction(
        message: message,
        actionLabel: 'Tentar novamente',
        onAction: _retry,
      ),
    };
  }
}
