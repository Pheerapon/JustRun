import UIKit
import Flutter
import GoogleMaps
import Firebase

// TODO: Import google_mobile_ads
import google_mobile_ads

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    // For google map feature
    // (!) API key for testing: AIzaSyA_CbzqJwkMOfoErelb3eLa1ZZlPao1Fhk
    GMSServices.provideAPIKey("AIzaSyA_CbzqJwkMOfoErelb3eLa1ZZlPao1Fhk")
    // Default code:
    GeneratedPluginRegistrant.register(with: self)
    
    // Register ListTileNativeAdFactory
    let listTileFactory = ListTileNativeAdFactory()
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
        self,
        factoryId: "listTile",
        nativeAdFactory: listTileFactory
    )
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
