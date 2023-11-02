// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../api/user.dart';
import '../include/navbar.dart';
import '../model/user_model.dart';
import '../widgets/snackbar.dart';
import 'dashboard.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _Home createState() => _Home();
}

class _Home extends State {
  final StreamController<UserModel> _userStreamController =
      StreamController<UserModel>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData() async {
    await fetchUser(_userStreamController);
  }

  StreamSubscription? internetconnection;
  bool isoffline = false;
  int _currentIndex = 0; // Initial index
  int _previousIndex = 0; // Store the previous index

  void _onMenuItemTap(int index) {
    setState(() {
      _previousIndex =
          _currentIndex; // Store the current index as the previous one
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    // Handle back button press
    if (_currentIndex != _previousIndex) {
      // If the current index is not the same as the previous one,
      // return to the previous index.
      setState(() {
        _currentIndex = _previousIndex;
      });
      return false; // Prevent the app from exiting
    } else {
      // If the current index is the same as the previous one,
      // allow the app to exit.
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser(_userStreamController);
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isoffline = false;
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    internetconnection!.cancel();
    _userStreamController.close();
  }

  void refresh() {
    _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        
        drawer: Navbar(onMenuItemTap: _onMenuItemTap),
        appBar: AppBar(
          title: Text(_currentIndex == 0 ? "Dashboard" : "Profile"),
          centerTitle: true,
        ),
        bottomNavigationBar: isoffline
            ? SizedBox(
                height: 50,
                child: BottomAppBar(
                  elevation: 0,
                  child: Center(
                    child: Container(
                      child: snack("You are currently Offline", isoffline),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            Dashboard(),
            Profile(),
          ],
        ),
        // use SizedBox to contrain the AppMenu to a fixed width
      ),
    );
  }


}
