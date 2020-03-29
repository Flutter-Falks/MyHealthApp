import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/notifiers/registered_cases_model.dart';
import 'package:selftrackingapp/page/screen/case_details_screen.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';
import 'package:selftrackingapp/page/screen/selected_case_detail_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';

import 'custom_text.dart';

class CaseItem extends StatelessWidget {
  final ReportedCase _case;

  CaseItem(this._case);

  @override
  Widget build(BuildContext context) {
//    var source = _case.isLocal ? 'Local' : 'Imported';
//    source += ', from: ' +
//        (_case.isFromFacility ? 'Quarantine Facility' : 'Community');
    return GestureDetector(
      child: Container(
        width: 100.0,
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 12.0, offset: Offset(0, 4.0))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.trip_origin,
              size: 18.0,
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      _case.caseNumber,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 6.0),
                    CustomText(
                      formatDate(_case.createdAt,
                          [yy, '-', M, '-', d, ' ', h, ':', nn, ' ', am]),
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  _case.isLocal ? Colors.green : Colors.amber,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CustomText(
                              _case.isLocal
                                  ? AppLocalizations.of(context)
                                      .translate("case_item_local")
                                  : AppLocalizations.of(context)
                                      .translate("case_item_foreign"),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  _case.isLocal ? Colors.purple : Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CustomText(
                              _case.isFromFacility
                                  ? AppLocalizations.of(context)
                                      .translate("case_item_community")
                                  : AppLocalizations.of(context)
                                      .translate("case_item_quarantine"),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    CustomText(
                      _case.message,
                    ),
                    SizedBox(height: 16.0),
                    CustomText(
                      AppLocalizations.of(context)
                          .translate("case_item_reported_locations"),
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 6.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _case.locations
                          .map((location) => Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(location.address),
                                  CustomText(
                                    formatDate(location.from, [
                                          yy,
                                          '-',
                                          M,
                                          '-',
                                          d,
                                          ' ',
                                          h,
                                          ':',
                                          nn,
                                          ' ',
                                          am
                                        ]) +
                                        " to " +
                                        formatDate(location.to, [
                                          yy,
                                          '-',
                                          M,
                                          '-',
                                          d,
                                          ' ',
                                          h,
                                          ':',
                                          nn,
                                          ' ',
                                          am
                                        ]),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  SizedBox(
                                    height: 6.0,
                                  )
                                ],
                              )))
                          .toList(),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: !Provider.of<RegisteredCasesModel>(context)
                                .reportedCases
                                .contains(_case)
                            ? RaisedButton(
                                color: TrackerColors.primaryColor,
                                child: CustomText(
                                  AppLocalizations.of(context)
                                      .translate("case_item_register"),
                                  style: TextStyle(color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                onPressed: () {
                                  Provider.of<RegisteredCasesModel>(context,
                                          listen: false)
                                      .add(
                                    _case,
                                  );
                                  RegisteredCasesModel model =
                                      Provider.of<RegisteredCasesModel>(context,
                                          listen: false);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider.value(
                                      value: model,
                                      child: UserRegisterScreen(),
                                    ),
                                  ));
                                },
                              )
                            : CustomText(
                                AppLocalizations.of(context)
                                    .translate("case_item_already_register"),
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => _showCasDetails(context, _case.id),
    );
  }

  void _showCasDetails(BuildContext context, int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectedCaseDetailScreen(
                  reportedCase: _case,
                )));
  }
}
