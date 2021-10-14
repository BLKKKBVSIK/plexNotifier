import 'package:flutter/material.dart';
import 'package:plex_notifier/ui/home/homepage_viewmodel.dart';
import 'package:stacked/stacked.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: const Text("PleX Notifier"),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Webhook URL',
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: TextField(
                        controller: model.textfieldController,
                        onChanged: (newValue) {
                          model.setText(newValue);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("Start Daemon"),
                          ),
                          SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("Stop Daemon"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  model.saveData();
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ));
  }
}
