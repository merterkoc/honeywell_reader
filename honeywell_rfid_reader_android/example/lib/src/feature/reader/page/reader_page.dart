import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honeywell_reader_android_example/src/animation/type_text_animation.dart';
import 'package:honeywell_reader_android_example/src/bloc/rfid_manager_bloc.dart';

class ReaderPage extends StatelessWidget {
  const ReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reader'),
      ),
      floatingActionButton: BlocBuilder<RfidManagerBloc, RfidManagerState>(
        buildWhen: (previous, current) =>
            previous.isReading != current.isReading,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state.isReading) {
                context.read<RfidManagerBloc>().add(const ReadStop());
              } else {
                context.read<RfidManagerBloc>().add(const ReadStart());
              }
            },
            child: state.isReading
                ? const Icon(Icons.stop)
                : const Icon(Icons.play_arrow),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<RfidManagerBloc, RfidManagerState>(
                  buildWhen: (previous, current) =>
                      previous.isReading != current.isReading,
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      duration: const Duration(milliseconds: 200),
                      child: state.isReading
                          ? const TypingTextAnimation(text: 'Scanning...')
                          : const Text('No Scanning'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<RfidManagerBloc>().add(const ClearTags());
                  },
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),
          BlocBuilder<RfidManagerBloc, RfidManagerState>(
            buildWhen: (previous, current) => previous.tags != current.tags,
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.tags.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(state.tags.elementAt(index)),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
