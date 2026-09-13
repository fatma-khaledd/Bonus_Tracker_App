import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return const Center(child: Text('تم تحميل البيانات بنجاح'));
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('مرحباً بك'));
          },
        ),
      ),
    );
  }
}
