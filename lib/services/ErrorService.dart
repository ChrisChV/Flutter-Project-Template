import 'package:catcher/catcher_plugin.dart';
import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/utils/utils.dart';
import 'package:sentry/sentry.dart';

class ErrorService{

  static final SentryClient _sentry = AppConfiguration.SENTRY_DSN_STRING != "" ?
                      SentryClient(dsn: AppConfiguration.SENTRY_DSN_STRING) :
                      null;


  static void sendError(dynamic error){
    try{
      throw(error);
    }
    catch(_error, stacktrace){
      if(Utils.isOnTest()) throw(error);
      Catcher.reportCheckedError(error, stacktrace);
    }
  }

  static Map<String, CatcherOptions> getCatcherConfig(){
    CatcherOptions debugOptions = CatcherOptions(SilentReportMode(), [ConsoleHandler()]);
    CatcherOptions releaseOptions = CatcherOptions(SilentReportMode(),
        _sentry == null ?  [ConsoleHandler()] : [ConsoleHandler(), SentryHandler(_sentry),]
    );
    CatcherOptions profileOptions = CatcherOptions(SilentReportMode(), [ConsoleHandler()]);
    return {
      'debug': debugOptions,
      'release': releaseOptions,
      'profile': profileOptions,
    };
  }

}