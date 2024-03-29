import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Gap(10),
            // Top Half
            NumberTriviaDisplay(),
            Gap(20),
            // Bottom Half
            NumberTriviaForm(),
          ],
        ),
      ),
    );
  }
}
