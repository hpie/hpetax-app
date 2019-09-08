import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:device_id/device_id.dart';

class DeviceData {
  get_data() {
    var uuid = new Uuid();

    // Generate a v1 (time-based) id
    /*
    uuid.v1();
    print("ppppppppppppppppppp");
    print(uuid.v1());
    print("ppppppppppppppppppp");
    */

    return uuid.v1();
  }
}