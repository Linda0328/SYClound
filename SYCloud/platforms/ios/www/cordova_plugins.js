cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "id": "shengyuan-plugin-module.Version",
        "file": "plugins/shengyuan-plugin-module/www/Version.js",
        "pluginId": "shengyuan-plugin-module",
        "clobbers": [
            "syapp.version"
        ]
    },
    {
       "id": "shengyuan-plugin-module.CachePlugin",
       "file": "plugins/shengyuan-plugin-module/www/CachePlugin.js",
       "pluginId": "shengyuan-plugin-module",
       "clobbers": [
            "syapp.cache"
        ]
    },
    {
      "id": "shengyuan-plugin-module.EventPlugin",
      "file": "plugins/shengyuan-plugin-module/www/EventPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
            "syapp.event"
        ]
    },
    {
      "id": "shengyuan-plugin-module.IntentPlugin",
      "file": "plugins/shengyuan-plugin-module/www/IntentPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
            "syapp.intent"
        ]
    },
    {
      "id": "shengyuan-plugin-module.LoadingPlugin",
      "file": "plugins/shengyuan-plugin-module/www/LoadingPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
             "syapp.loading"
        ]
    },
    {
      "id": "shengyuan-plugin-module.LocationPlugin",
      "file": "plugins/shengyuan-plugin-module/www/LocationPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
             "syapp.location"
        ]
    },
    {
      "id": "shengyuan-plugin-module.PaymentPlugin",
      "file": "plugins/shengyuan-plugin-module/www/PaymentPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
             "syapp.payment"
        ]
    },
    {
      "id": "shengyuan-plugin-module.ResultPlugin",
      "file": "plugins/shengyuan-plugin-module/www/ResultPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
            "syapp.result"
        ]
    },
    {
      "id": "shengyuan-plugin-module.ScanPlugin",
      "file": "plugins/shengyuan-plugin-module/www/ScanPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
            "syapp.scan"
        ]
    },
    {
      "id": "shengyuan-plugin-module.SecurePlugin",
      "file": "plugins/shengyuan-plugin-module/www/SecurePlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
            "syapp.secure"
        ]
    },
    {
      "id": "shengyuan-plugin-module.PaymentCloudPlugin",
      "file": "plugins/shengyuan-plugin-module/www/PaymentCloudPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
            "syapp.cloud"
         ]
    },
    {
      "id": "shengyuan-plugin-module.RequestPlugin",
      "file": "plugins/shengyuan-plugin-module/www/RequestPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
            "syapp.request"
         ]
    },
    {
      "id": "shengyuan-plugin-module.SharePlugin",
      "file": "plugins/shengyuan-plugin-module/www/SharePlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
            "syapp.share"
         ]
    },
    {
      "id": "shengyuan-plugin-module.PhotoPlugin",
      "file": "plugins/shengyuan-plugin-module/www/PhotoPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
             "syapp.slide"
         ]
    },
    {
      "id": "shengyuan-plugin-module.PatternLockPlugin",
      "file": "plugins/shengyuan-plugin-module/www/PatternLockPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
                   "syapp.lock"
         ]
    },
    {
      "id": "shengyuan-plugin-module.AuthPlugin",
      "file": "plugins/shengyuan-plugin-module/www/AuthPlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
                   "syapp.auth"
         ]
    },
    {
      "id": "shengyuan-plugin-module.GuidencePlugin",
      "file": "plugins/shengyuan-plugin-module/www/GuidencePlugin.js",
      "pluginId": "shengyuan-plugin-module",
      "clobbers": [
                   "syapp.tips"
                   ]
    },
    {
        "id": "cordova-plugin-camera.Camera",
        "file": "plugins/cordova-plugin-camera/www/CameraConstants.js",
        "pluginId": "cordova-plugin-camera",
        "clobbers": [
            "Camera"
        ]
    },
    {
        "id": "cordova-plugin-camera.CameraPopoverOptions",
        "file": "plugins/cordova-plugin-camera/www/CameraPopoverOptions.js",
        "pluginId": "cordova-plugin-camera",
        "clobbers": [
            "CameraPopoverOptions"
        ]
    },
    {
        "id": "cordova-plugin-camera.camera",
        "file": "plugins/cordova-plugin-camera/www/Camera.js",
        "pluginId": "cordova-plugin-camera",
        "clobbers": [
            "navigator.camera"
        ]
    },
    {
        "id": "cordova-plugin-camera.CameraPopoverHandle",
        "file": "plugins/cordova-plugin-camera/www/ios/CameraPopoverHandle.js",
        "pluginId": "cordova-plugin-camera",
        "clobbers": [
            "CameraPopoverHandle"
        ]
    },
    {
        "id": "cordova-plugin-dialogs.notification",
        "file": "plugins/cordova-plugin-dialogs/www/notification.js",
        "pluginId": "cordova-plugin-dialogs",
        "merges": [
            "navigator.notification"
        ]
    },
    {
        "id": "cordova-plugin-file.DirectoryEntry",
        "file": "plugins/cordova-plugin-file/www/DirectoryEntry.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.DirectoryEntry"
        ]
    },
    {
        "id": "cordova-plugin-file.DirectoryReader",
        "file": "plugins/cordova-plugin-file/www/DirectoryReader.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.DirectoryReader"
        ]
    },
    {
        "id": "cordova-plugin-file.Entry",
        "file": "plugins/cordova-plugin-file/www/Entry.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.Entry"
        ]
    },
    {
        "id": "cordova-plugin-file.File",
        "file": "plugins/cordova-plugin-file/www/File.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.File"
        ]
    },
    {
        "id": "cordova-plugin-file.FileEntry",
        "file": "plugins/cordova-plugin-file/www/FileEntry.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileEntry"
        ]
    },
    {
        "id": "cordova-plugin-file.FileError",
        "file": "plugins/cordova-plugin-file/www/FileError.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileError"
        ]
    },
    {
        "id": "cordova-plugin-file.FileReader",
        "file": "plugins/cordova-plugin-file/www/FileReader.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileReader"
        ]
    },
    {
        "id": "cordova-plugin-file.FileSystem",
        "file": "plugins/cordova-plugin-file/www/FileSystem.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileSystem"
        ]
    },
    {
        "id": "cordova-plugin-file.FileUploadOptions",
        "file": "plugins/cordova-plugin-file/www/FileUploadOptions.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileUploadOptions"
        ]
    },
    {
        "id": "cordova-plugin-file.FileUploadResult",
        "file": "plugins/cordova-plugin-file/www/FileUploadResult.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileUploadResult"
        ]
    },
    {
        "id": "cordova-plugin-file.FileWriter",
        "file": "plugins/cordova-plugin-file/www/FileWriter.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileWriter"
        ]
    },
    {
        "id": "cordova-plugin-file.Flags",
        "file": "plugins/cordova-plugin-file/www/Flags.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.Flags"
        ]
    },
    {
        "id": "cordova-plugin-file.LocalFileSystem",
        "file": "plugins/cordova-plugin-file/www/LocalFileSystem.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.LocalFileSystem"
        ],
        "merges": [
            "window"
        ]
    },
    {
        "id": "cordova-plugin-file.Metadata",
        "file": "plugins/cordova-plugin-file/www/Metadata.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.Metadata"
        ]
    },
    {
        "id": "cordova-plugin-file.ProgressEvent",
        "file": "plugins/cordova-plugin-file/www/ProgressEvent.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.ProgressEvent"
        ]
    },
    {
        "id": "cordova-plugin-file.fileSystems",
        "file": "plugins/cordova-plugin-file/www/fileSystems.js",
        "pluginId": "cordova-plugin-file"
    },
    {
        "id": "cordova-plugin-file.requestFileSystem",
        "file": "plugins/cordova-plugin-file/www/requestFileSystem.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.requestFileSystem"
        ]
    },
    {
        "id": "cordova-plugin-file.resolveLocalFileSystemURI",
        "file": "plugins/cordova-plugin-file/www/resolveLocalFileSystemURI.js",
        "pluginId": "cordova-plugin-file",
        "merges": [
            "window"
        ]
    },
    {
        "id": "cordova-plugin-file.isChrome",
        "file": "plugins/cordova-plugin-file/www/browser/isChrome.js",
        "pluginId": "cordova-plugin-file",
        "runs": true
    },
    {
        "id": "cordova-plugin-file.iosFileSystem",
        "file": "plugins/cordova-plugin-file/www/ios/FileSystem.js",
        "pluginId": "cordova-plugin-file",
        "merges": [
            "FileSystem"
        ]
    },
    {
        "id": "cordova-plugin-file.fileSystems-roots",
        "file": "plugins/cordova-plugin-file/www/fileSystems-roots.js",
        "pluginId": "cordova-plugin-file",
        "runs": true
    },
    {
        "id": "cordova-plugin-file.fileSystemPaths",
        "file": "plugins/cordova-plugin-file/www/fileSystemPaths.js",
        "pluginId": "cordova-plugin-file",
        "merges": [
            "cordova"
        ],
        "runs": true
    },
    {
        "id": "cordova-plugin-file-transfer.FileTransferError",
        "file": "plugins/cordova-plugin-file-transfer/www/FileTransferError.js",
        "pluginId": "cordova-plugin-file-transfer",
        "clobbers": [
            "window.FileTransferError"
        ]
    },
    {
        "id": "cordova-plugin-file-transfer.FileTransfer",
        "file": "plugins/cordova-plugin-file-transfer/www/FileTransfer.js",
        "pluginId": "cordova-plugin-file-transfer",
        "clobbers": [
            "window.FileTransfer"
        ]
    },
    {
        "id": "cordova-plugin-geolocation.Coordinates",
        "file": "plugins/cordova-plugin-geolocation/www/Coordinates.js",
        "pluginId": "cordova-plugin-geolocation",
        "clobbers": [
            "Coordinates"
        ]
    },
    {
        "id": "cordova-plugin-geolocation.PositionError",
        "file": "plugins/cordova-plugin-geolocation/www/PositionError.js",
        "pluginId": "cordova-plugin-geolocation",
        "clobbers": [
            "PositionError"
        ]
    },
    {
        "id": "cordova-plugin-geolocation.Position",
        "file": "plugins/cordova-plugin-geolocation/www/Position.js",
        "pluginId": "cordova-plugin-geolocation",
        "clobbers": [
            "Position"
        ]
    },
    {
        "id": "cordova-plugin-geolocation.geolocation",
        "file": "plugins/cordova-plugin-geolocation/www/geolocation.js",
        "pluginId": "cordova-plugin-geolocation",
        "clobbers": [
            "navigator.geolocation"
        ]
    },
    {
        "id": "cordova-plugin-statusbar.statusbar",
        "file": "plugins/cordova-plugin-statusbar/www/statusbar.js",
        "pluginId": "cordova-plugin-statusbar",
        "clobbers": [
            "window.StatusBar"
        ]
    },
    {
        "id": "cordova-plugin-vibration.notification",
        "file": "plugins/cordova-plugin-vibration/www/vibration.js",
        "pluginId": "cordova-plugin-vibration",
        "merges": [
            "navigator.notification",
            "navigator"
        ]
    },
    {
        "id": "cordova-plugin-x-toast.Toast",
        "file": "plugins/cordova-plugin-x-toast/www/Toast.js",
        "pluginId": "cordova-plugin-x-toast",
        "clobbers": [
            "window.plugins.toast"
        ]
    },
    {
        "id": "cordova-plugin-x-toast.tests",
        "file": "plugins/cordova-plugin-x-toast/test/tests.js",
        "pluginId": "cordova-plugin-x-toast"
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.3.2",
    "cordova-plugin-device": "1.1.5",
    "cordova-plugin-compat": "1.1.0",
    "cordova-plugin-camera": "2.4.0",
    "cordova-plugin-dialogs": "1.3.2",
    "cordova-plugin-file": "4.3.2",
    "cordova-plugin-file-transfer": "1.6.2",
    "cordova-plugin-geolocation": "2.4.2",
    "cordova-plugin-statusbar": "2.2.2",
    "cordova-plugin-vibration": "2.1.4",
    "cordova-plugin-x-toast": "2.6.0",
    "shengyuan-plugin-module":"1.0.1"
};
// BOTTOM OF METADATA
});
