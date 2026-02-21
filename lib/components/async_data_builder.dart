import 'package:flutter/material.dart';
import '/components/loading_indicator.dart';
import '/pages/error_page/error_page_widget.dart';

/// A reusable wrapper around [FutureBuilder] that provides a consistent
/// loading indicator and error handling behaviour across the app.
///
/// By default, it shows a full‑screen [LoadingIndicator] while waiting, and an
/// [ErrorPageWidget] if the future completes with an error. The [builder]
/// callback is invoked with the non-null data when available.
class AsyncDataBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final bool fullScreenLoading;
  final EdgeInsetsGeometry? padding;

  const AsyncDataBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.fullScreenLoading = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (fullScreenLoading) {
            return const LoadingIndicator(isFullScreen: true);
          }
          return Center(child: LoadingIndicator());
        }
        if (snapshot.hasError) {
          return ErrorPageWidget(
            type: ErrorType.generalError,
            customMessage: snapshot.error.toString(),
          );
        }
        if (snapshot.hasData) {
          return builder(context, snapshot.data as T);
        }
        // Fallback for null data: treat as empty
        return const SizedBox.shrink();
      },
    );
  }
}
