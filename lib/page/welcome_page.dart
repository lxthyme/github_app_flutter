import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_app/common/dao/user_dao.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/redux/gsy_state.dart';
import 'package:gsy_app/widget/diff_scale_text.dart';
import 'package:gsy_app/widget/mole_widget.dart';
import 'package:redux/redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;
  String text = '';
  double fontSize = 76;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    Store<GSYState> store = StoreProvider.of(context);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        text = 'Welcome';
        fontSize = 60;
      });
    });
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        text = "GSYGithubApp";
        fontSize = 60;
      });
    });

    Future.delayed(const Duration(seconds: 3, milliseconds: 500), () {
      UserDao.initUserInfo(store).then((res) {
        if (res != null && res.result) {
          NavigatorUtils.goHome(context);
        } else {
          NavigatorUtils.goLogin(context);
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(
      builder: (context, vm) {
        double size = 200;
        return Material(
          color: GSYColors.white,
          child: Stack(
            children: [
              const Center(
                child: Image(image: AssetImage('static/images/welcome.png')),
              ),
              Align(
                alignment: Alignment(0, 0.3),
                child: DiffScaleText(
                  text: text,
                  textStyle: GoogleFonts.akronim().copyWith(
                    color: GSYColors.primaryDarkValue,
                    fontSize: fontSize,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.8),
                child: Mole(),
              ),
              Align(
                alignment: Alignment(0, .9),
                child: Container(
                  width: size,
                  height: size,
                  child: RiveAnimation.asset(
                    'static/file/launch.riv',
                    animations: ['lookup'],
                    onInit: (arb) {
                      var controller = StateMachineController.fromArtboard(arb, 'birb');
                      var smi = controller?.findInput<bool>('dance');
                      arb.addController(controller!);
                      smi?.value = true;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
