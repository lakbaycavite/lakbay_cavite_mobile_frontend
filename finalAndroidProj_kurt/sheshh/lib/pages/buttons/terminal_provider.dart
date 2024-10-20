import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'jeepvan_terminal_model.dart';
import 'tricycle_terminal_model.dart';// Import your model class

class TerminalProvider with ChangeNotifier{
  final List<TricycleTerminal> _terminals = [
    TricycleTerminal(name: 'ICAP TODA(Alapan route,)',
      location: const gmaps.LatLng(14.424081624991894, 120.9413363934624),
      route: [
        const gmaps.LatLng(14.423783, 120.941017), // Nueno Ave
        const gmaps.LatLng(14.428813, 120.936649),
        const gmaps.LatLng(14.429120, 120.937016),
        const gmaps.LatLng(14.429324, 120.936920),
        const gmaps.LatLng(14.427849, 120.933225),
        const gmaps.LatLng(14.429244, 120.932198),
        const gmaps.LatLng(14.428805, 120.916337),
        const gmaps.LatLng(14.405451, 120.922911),
        const gmaps.LatLng(14.405451, 120.925416),//Jabee bucandala
      ],
      fareMatrices: [
        'assets/fareMtrix.jpg'
      ],
      puvType: 'Tricycle', // Add this line
      landmarks: [
        'Jollibee Bucandala',
        'Imus Institute of Science and Technology',
        'Alapan Elementary School'
      ],
    ),
    TricycleTerminal(name: 'ICAP TODA(NIA Road route)',
      location: const gmaps.LatLng(14.424081624991894, 120.9413363934624),
      route: [
        const gmaps.LatLng(14.423783, 120.941017), // Nueno Ave
        const gmaps.LatLng(14.428813, 120.936649),
        const gmaps.LatLng(14.429120, 120.937016),
        const gmaps.LatLng(14.429324, 120.936920),
        const gmaps.LatLng(14.427849, 120.933225),
        const gmaps.LatLng(14.429244, 120.932198),
        const gmaps.LatLng(14.428567, 120.924554),
        const gmaps.LatLng(14.428576, 120.923435),
        const gmaps.LatLng(14.428632, 120.922290),
        const gmaps.LatLng(14.428217, 120.922248), //Nia road
        const gmaps.LatLng(14.426830, 120.922158),
        const gmaps.LatLng(14.426669, 120.923170),
        const gmaps.LatLng(14.423910, 120.923237),
        const gmaps.LatLng(14.421550, 120.923529),
        const gmaps.LatLng(14.414687, 120.924009),
        const gmaps.LatLng(14.413620, 120.924259),
        const gmaps.LatLng(14.413123, 120.924288),
        const gmaps.LatLng(14.412695, 120.924181),
        const gmaps.LatLng(14.412071, 120.924057),
        const gmaps.LatLng(14.410863, 120.924028),
        const gmaps.LatLng(14.407746, 120.925219),
        const gmaps.LatLng(14.406634, 120.925337),
        const gmaps.LatLng(14.406224, 120.925492),
        const gmaps.LatLng(14.405451, 120.925416),//Jabee bucandala
      ],
      fareMatrices: [
        'assets/fareMtrix1.jpg'
      ],
      puvType: 'Tricycle', // Add this line
      landmarks: [
        'Robinsons Imus',
        'Imus City Hall',
        'NIA Road Market'
      ],
    ),

    TricycleTerminal(name: 'CPAI TODA(ALAPAN Road route)',
      location: const gmaps.LatLng(14.440676, 120.911748),
      route: [
        const gmaps.LatLng(14.440676, 120.911748), // CPAI toda
        const gmaps.LatLng(14.440299, 120.912086),
        const gmaps.LatLng(14.440214, 120.912137),
        const gmaps.LatLng(14.440004, 120.912214),
        const gmaps.LatLng(14.439927, 120.912236),
        const gmaps.LatLng(14.438711, 120.912519),
        const gmaps.LatLng(14.438264, 120.912652),
        const gmaps.LatLng(14.438014, 120.912734),
        const gmaps.LatLng(14.437362, 120.913055),
        const gmaps.LatLng(14.437236, 120.913130),
        const gmaps.LatLng(14.436650, 120.913529),
        const gmaps.LatLng(14.436249, 120.914025),
        const gmaps.LatLng(14.435766, 120.914542),
        const gmaps.LatLng(14.435629, 120.914667),
        const gmaps.LatLng(14.434408, 120.915243),
        const gmaps.LatLng(14.433259, 120.915864),
        const gmaps.LatLng(14.433089, 120.915932),
        const gmaps.LatLng(14.432363, 120.916147),
        const gmaps.LatLng(14.432174, 120.916184),
        const gmaps.LatLng(14.430705, 120.916252),
        const gmaps.LatLng(14.430356, 120.916285),
        const gmaps.LatLng(14.428836, 120.916339),//carbag sa left
        const gmaps.LatLng(14.427673, 120.916363),
        const gmaps.LatLng(14.427255, 120.916411),
        const gmaps.LatLng(14.426946, 120.916344),
        const gmaps.LatLng(14.426387, 120.916174),
        const gmaps.LatLng(14.425829, 120.915924),
        const gmaps.LatLng(14.425537, 120.915823),
        const gmaps.LatLng(14.425425, 120.915798),
        const gmaps.LatLng(14.423734, 120.915821),
        const gmaps.LatLng(14.422701, 120.915872),//toclong
        const gmaps.LatLng(14.421350, 120.916179),
        const gmaps.LatLng(14.420595, 120.916365),
        const gmaps.LatLng(14.418505, 120.916661),
        const gmaps.LatLng(14.418066, 120.916738),
        const gmaps.LatLng(14.417932, 120.916778),
        const gmaps.LatLng(14.416807, 120.917204),
        const gmaps.LatLng(14.415923, 120.917639),
        const gmaps.LatLng(14.414678, 120.918595),
        const gmaps.LatLng(14.414045, 120.919074),
        const gmaps.LatLng(14.413878, 120.919307),
        const gmaps.LatLng(14.413279, 120.920472),
        const gmaps.LatLng(14.410618, 120.921586),
        const gmaps.LatLng(14.409866, 120.921798),
        const gmaps.LatLng(14.408510, 120.922012),
        const gmaps.LatLng(14.407850, 120.922169),
        const gmaps.LatLng(14.407496, 120.922447),
        const gmaps.LatLng(14.405447, 120.922896),
        const gmaps.LatLng(14.405447, 120.922896),
        const gmaps.LatLng(14.405451, 120.925416),//Jabee bucandala

      ],
      fareMatrices: [
        'assets/fareMtrix1.jpg'
      ],
      puvType: 'Tricycle', // Add this line
      landmarks: [
        'Robinsons Imus',
        'Imus City Hall',
        'NIA Road Market'
      ],
    ),
    TricycleTerminal(name: 'CPAI TODA(NIA Road route)',
      location: const gmaps.LatLng(14.440676, 120.911748),
      route: [
        const gmaps.LatLng(14.440676, 120.911748), // CPAI toda
        const gmaps.LatLng(14.440299, 120.912086),
        const gmaps.LatLng(14.440214, 120.912137),
        const gmaps.LatLng(14.440004, 120.912214),
        const gmaps.LatLng(14.439927, 120.912236),
        const gmaps.LatLng(14.438711, 120.912519),
        const gmaps.LatLng(14.438264, 120.912652),
        const gmaps.LatLng(14.438014, 120.912734),
        const gmaps.LatLng(14.437362, 120.913055),
        const gmaps.LatLng(14.437236, 120.913130),
        const gmaps.LatLng(14.436650, 120.913529),
        const gmaps.LatLng(14.436249, 120.914025),
        const gmaps.LatLng(14.435766, 120.914542),
        const gmaps.LatLng(14.435629, 120.914667),
        const gmaps.LatLng(14.434408, 120.915243),
        const gmaps.LatLng(14.433259, 120.915864),
        const gmaps.LatLng(14.433089, 120.915932),
        const gmaps.LatLng(14.432363, 120.916147),
        const gmaps.LatLng(14.432174, 120.916184),
        const gmaps.LatLng(14.430705, 120.916252),
        const gmaps.LatLng(14.430356, 120.916285),
        const gmaps.LatLng(14.428836, 120.916339),//carbag sa left
        const gmaps.LatLng(14.428772, 120.918996),
        const gmaps.LatLng(14.428689, 120.919610),
        const gmaps.LatLng(14.428634, 120.922263),
        const gmaps.LatLng(14.428217, 120.922248), //Nia road
        const gmaps.LatLng(14.426830, 120.922158),
        const gmaps.LatLng(14.426669, 120.923170),
        const gmaps.LatLng(14.423910, 120.923237),
        const gmaps.LatLng(14.421550, 120.923529),
        const gmaps.LatLng(14.414687, 120.924009),
        const gmaps.LatLng(14.413620, 120.924259),
        const gmaps.LatLng(14.413123, 120.924288),
        const gmaps.LatLng(14.412695, 120.924181),
        const gmaps.LatLng(14.412071, 120.924057),
        const gmaps.LatLng(14.410863, 120.924028),
        const gmaps.LatLng(14.407746, 120.925219),
        const gmaps.LatLng(14.406634, 120.925337),
        const gmaps.LatLng(14.406224, 120.925492),
        const gmaps.LatLng(14.405451, 120.925416),//Jabee bucandala

      ],
      fareMatrices: [
        'assets/fareMtrix1.jpg'
      ],
      puvType: 'Tricycle', // Add this line
      landmarks: [
        'Robinsons Imus',
        'Imus City Hall',
        'NIA Road Market'
      ],
    ),


    TricycleTerminal(name: 'Tanzang Luma TODA(Mabolo Route)',
      location: const gmaps.LatLng(14.423044, 120.942189),
      route: [
        const gmaps.LatLng(14.423044, 120.942189),// CPAI toda
        const gmaps.LatLng(14.423811, 120.942070),
        const gmaps.LatLng(14.424141, 120.942000),
        const gmaps.LatLng(14.424786, 120.941791),
        const gmaps.LatLng(14.426442, 120.941432),
        const gmaps.LatLng(14.427047, 120.941322),
        const gmaps.LatLng(14.427987, 120.940866),
        const gmaps.LatLng(14.427800, 120.940343),
        const gmaps.LatLng(14.429310, 120.939267),
        const gmaps.LatLng(14.429847, 120.940022),
        const gmaps.LatLng(14.429906, 120.940225),
        const gmaps.LatLng(14.430810, 120.940303),
        const gmaps.LatLng(14.431665, 120.940049),
        const gmaps.LatLng(14.432218, 120.939511),
        const gmaps.LatLng(14.432613, 120.938696),
        const gmaps.LatLng(14.433141, 120.938353),
        const gmaps.LatLng(14.433325, 120.938274),
        const gmaps.LatLng(14.433769, 120.938038),
        const gmaps.LatLng(14.434138, 120.937803),
        const gmaps.LatLng(14.434752, 120.937631),
        const gmaps.LatLng(14.434979, 120.937535),
        const gmaps.LatLng(14.435294, 120.937241),
        const gmaps.LatLng(14.435640, 120.936947),
        const gmaps.LatLng(14.435825, 120.936829),
        const gmaps.LatLng(14.436020, 120.936733),
        const gmaps.LatLng(14.436269, 120.936667),
        const gmaps.LatLng(14.436877, 120.936565),
        const gmaps.LatLng(14.437763, 120.936642),
        const gmaps.LatLng(14.437886, 120.936600),
        const gmaps.LatLng(14.438051, 120.936511),
        const gmaps.LatLng(14.438332, 120.936310),
        const gmaps.LatLng(14.438782, 120.936062),
        const gmaps.LatLng(14.439802, 120.935656),
        const gmaps.LatLng(14.439864, 120.935608),
        const gmaps.LatLng(14.440500, 120.934850),
        const gmaps.LatLng(14.441478, 120.934071),
        const gmaps.LatLng(14.442624, 120.933873),
        const gmaps.LatLng(14.442780, 120.933660),
        const gmaps.LatLng(14.442865, 120.933487),
        const gmaps.LatLng(14.442914, 120.933275),
        const gmaps.LatLng(14.442959, 120.932868),
        const gmaps.LatLng(14.442930, 120.932687),
        const gmaps.LatLng(14.442856, 120.932518),
        const gmaps.LatLng(14.442712, 120.932338),
        const gmaps.LatLng(14.442236, 120.931789),
        const gmaps.LatLng(14.442270, 120.931624),
        const gmaps.LatLng(14.442470, 120.931452),
        const gmaps.LatLng(14.442673, 120.931402),
        const gmaps.LatLng(14.442859, 120.931423),
        const gmaps.LatLng(14.443426, 120.931523),
        const gmaps.LatLng(14.444247, 120.931591),
        const gmaps.LatLng(14.444474, 120.931640),
        const gmaps.LatLng(14.445180, 120.931638),
        const gmaps.LatLng(14.445573, 120.931557),
        const gmaps.LatLng(14.445981, 120.931355),
        const gmaps.LatLng(14.446520, 120.930900),
        const gmaps.LatLng(14.447189, 120.929498),
        const gmaps.LatLng(14.447548, 120.929288),
        const gmaps.LatLng(14.449112, 120.929345),
        const gmaps.LatLng(14.449727, 120.929206),
        const gmaps.LatLng(14.450270, 120.928872),//mabolo

      ],
      fareMatrices: [
        'assets/fareMtrix1.jpg'
      ],
      puvType: 'Tricycle', // Add this line
      landmarks: [
        'Robinsons Imus',
        'Imus City Hall',
        'NIA Road Market'
      ],
    ),
    TricycleTerminal(name: 'Buhay na Tubig TODA(pagasa Road route)',
      location: const gmaps.LatLng(14.427508, 120.944670),
      route: [
        const gmaps.LatLng(14.427508, 120.944670), // BNT toda
        const gmaps.LatLng(14.427312, 120.945231),
        const gmaps.LatLng(14.426758, 120.945636),
        const gmaps.LatLng(14.426309, 120.945881),
        const gmaps.LatLng(14.424908, 120.945768),
        const gmaps.LatLng(14.422776, 120.945865),
        const gmaps.LatLng(14.422416, 120.945978),
        const gmaps.LatLng(14.420598, 120.946893),
        const gmaps.LatLng(14.419899, 120.947087),
        const gmaps.LatLng(14.418187, 120.948172),
        const gmaps.LatLng(14.416043, 120.948741),
        const gmaps.LatLng(14.415803, 120.949150),
        const gmaps.LatLng(14.415638, 120.949836),
        const gmaps.LatLng(14.415461, 120.950035),
        const gmaps.LatLng(14.414670, 120.950423),
        const gmaps.LatLng(14.413128, 120.951797),
        const gmaps.LatLng(14.407587, 120.954878),
        const gmaps.LatLng(14.407226, 120.955271),
        const gmaps.LatLng(14.407079, 120.955526),
        const gmaps.LatLng(14.406925, 120.956052),//patindig dulo
        const gmaps.LatLng(14.406888, 120.956762),
        const gmaps.LatLng(14.405784, 120.957795),
        const gmaps.LatLng(14.405413, 120.957862),
        const gmaps.LatLng(14.405000, 120.958054),
        const gmaps.LatLng(14.404639, 120.958330),
        const gmaps.LatLng(14.404317, 120.958465),
        const gmaps.LatLng(14.404184, 120.958504),
        const gmaps.LatLng(14.402063, 120.958857),
        const gmaps.LatLng(14.401685, 120.958911),
        const gmaps.LatLng(14.401566, 120.958955),
        const gmaps.LatLng(14.400275, 120.959871),
        const gmaps.LatLng(14.399601, 120.960347),
        const gmaps.LatLng(14.399515, 120.960426),
        const gmaps.LatLng(14.399272, 120.960738),
        const gmaps.LatLng(14.398926, 120.961275),
        const gmaps.LatLng(14.398716, 120.961497),
        const gmaps.LatLng(14.398390, 120.961644),
        const gmaps.LatLng(14.397893, 120.961781),
        const gmaps.LatLng(14.397815, 120.961816),
        const gmaps.LatLng(14.397550, 120.961927),
        const gmaps.LatLng(14.397412, 120.962170),
        const gmaps.LatLng(14.397355, 120.962347),
        const gmaps.LatLng(14.396594, 120.963422),
        const gmaps.LatLng(14.395480, 120.965027),
        const gmaps.LatLng(14.394952, 120.964244),
        const gmaps.LatLng(14.394568, 120.965117),//avenida rizal


      ],
      fareMatrices: [
        'assets/fareMtrix1.jpg'
      ],
      puvType: 'Tricycle', // Add this line
      landmarks: [
        'Robinsons Imus',
        'Imus City Hall',
        'NIA Road Market'
      ],
    ),
    TricycleTerminal(name: 'Imus Jeepney Terminal(BDO)',
      location: const gmaps.LatLng(14.420627, 120.940525),
      route: [
        const gmaps.LatLng(14.420627, 120.940525), // Nueno Ave
        const gmaps.LatLng(14.420540, 120.940554),
        const gmaps.LatLng(14.420483, 120.940562),
        const gmaps.LatLng(14.420426, 120.940297),
        const gmaps.LatLng(14.420137, 120.940339),
        const gmaps.LatLng(14.419919, 120.940350),
        const gmaps.LatLng(14.419659, 120.940328),
        const gmaps.LatLng(14.419552, 120.940332),
        const gmaps.LatLng(14.419545, 120.940165),
        const gmaps.LatLng(14.419507, 120.939849),
        const gmaps.LatLng(14.419395, 120.939297),
        const gmaps.LatLng(14.419234, 120.938621),
        const gmaps.LatLng(14.419038, 120.938051),
        const gmaps.LatLng(14.419068, 120.937582),
        const gmaps.LatLng(14.419278, 120.936715),
        const gmaps.LatLng(14.419517, 120.935699),
        const gmaps.LatLng(14.419541, 120.935462),
        const gmaps.LatLng(14.416916, 120.935101),
        const gmaps.LatLng(14.415627, 120.935014),
        const gmaps.LatLng(14.414969, 120.934983),
        const gmaps.LatLng(14.410240, 120.935293),
        const gmaps.LatLng(14.409561, 120.935287),
        const gmaps.LatLng(14.409231, 120.935318),
        const gmaps.LatLng(14.406467, 120.935394),
        const gmaps.LatLng(14.406415, 120.933988),
        const gmaps.LatLng(14.406404, 120.932380),
        const gmaps.LatLng(14.406360, 120.932007),
        const gmaps.LatLng(14.406241, 120.931222),
        const gmaps.LatLng(14.406043, 120.929313),
        const gmaps.LatLng(14.405938, 120.928460),
        const gmaps.LatLng(14.405872, 120.928036),
        const gmaps.LatLng(14.405817, 120.927519),
        const gmaps.LatLng(14.405609, 120.926279),
        const gmaps.LatLng(14.405460, 120.925567),
        const gmaps.LatLng(14.401675, 120.926146),
        const gmaps.LatLng(14.401102, 120.926350),
        const gmaps.LatLng(14.400039, 120.926654),
        const gmaps.LatLng(14.398412, 120.927344),
        const gmaps.LatLng(14.397704, 120.927625),
        const gmaps.LatLng(14.397145, 120.927772),
        const gmaps.LatLng(14.396239, 120.927848),
        const gmaps.LatLng(14.395518, 120.927907),
        const gmaps.LatLng(14.395153, 120.927958),
        const gmaps.LatLng(14.394135, 120.928200),
        const gmaps.LatLng(14.392533, 120.928476),
        const gmaps.LatLng(14.391619, 120.928802),
        const gmaps.LatLng(14.390920, 120.928906),
        const gmaps.LatLng(14.390605, 120.928940),
        const gmaps.LatLng(14.390222, 120.928949),
        const gmaps.LatLng(14.389649, 120.928947),
        const gmaps.LatLng(14.389438, 120.928932),
        const gmaps.LatLng(14.389028, 120.928932),
        const gmaps.LatLng(14.387452, 120.929069),
        const gmaps.LatLng(14.387107, 120.929054),
        const gmaps.LatLng(14.386376, 120.928918),
        const gmaps.LatLng(14.385417, 120.928905),
        const gmaps.LatLng(14.384406, 120.928924),
        const gmaps.LatLng(14.384035, 120.928985),
        const gmaps.LatLng(14.383571, 120.929104),
        const gmaps.LatLng(14.382916, 120.929239),
        const gmaps.LatLng(14.382822, 120.929294),
        const gmaps.LatLng(14.382710, 120.929303),
        const gmaps.LatLng(14.382646, 120.929312),
        const gmaps.LatLng(14.382158, 120.929292),
        const gmaps.LatLng(14.381747, 120.929229),
        const gmaps.LatLng(14.381182, 120.929093),
        const gmaps.LatLng(14.381078, 120.929067),
        const gmaps.LatLng(14.380431, 120.928956),
        const gmaps.LatLng(14.379396, 120.928887),
        const gmaps.LatLng(14.378498, 120.928825),
        const gmaps.LatLng(14.377714, 120.928808),
        const gmaps.LatLng(14.377295, 120.928826),
        const gmaps.LatLng(14.376672, 120.928818),
        const gmaps.LatLng(14.376094, 120.928831),
        const gmaps.LatLng(14.375069, 120.928799),
        const gmaps.LatLng(14.374666, 120.928769),
        const gmaps.LatLng(14.374452, 120.928731),
        const gmaps.LatLng(14.374374, 120.928737),
        const gmaps.LatLng(14.373745, 120.928684),
        const gmaps.LatLng(14.372484, 120.928613),
        const gmaps.LatLng(14.372188, 120.928549),
        const gmaps.LatLng(14.371984, 120.928501),
        const gmaps.LatLng(14.371638, 120.928417),
        const gmaps.LatLng(14.371205, 120.928351),
        const gmaps.LatLng(14.371015, 120.928307),
        const gmaps.LatLng(14.370440, 120.928053),
        const gmaps.LatLng(14.368911, 120.927320),
        const gmaps.LatLng(14.368649, 120.927198),
        const gmaps.LatLng(14.368039, 120.927036),
        const gmaps.LatLng(14.367848, 120.927018),
        const gmaps.LatLng(14.367546, 120.927035),
        const gmaps.LatLng(14.365261, 120.927440),
        const gmaps.LatLng(14.364311, 120.927632),
        const gmaps.LatLng(14.363470, 120.927817),
        const gmaps.LatLng(14.363201, 120.927829),
        const gmaps.LatLng(14.362573, 120.927784),
        const gmaps.LatLng(14.361200, 120.927329),
        const gmaps.LatLng(14.358598, 120.926337),
        const gmaps.LatLng(14.357761, 120.925862),
        const gmaps.LatLng(14.356085, 120.924959),
        const gmaps.LatLng(14.356000, 120.924924),
        const gmaps.LatLng(14.355025, 120.924304),
        const gmaps.LatLng(14.354238, 120.923809),
        const gmaps.LatLng(14.354132, 120.923763),
        const gmaps.LatLng(14.353828, 120.923754),
        const gmaps.LatLng(14.352922, 120.923960),
        const gmaps.LatLng(14.352267, 120.924037),
        const gmaps.LatLng(14.350007, 120.924426),
        const gmaps.LatLng(14.348907, 120.924525),
        const gmaps.LatLng(14.348061, 120.924576),
        const gmaps.LatLng(14.347163, 120.924564),
        const gmaps.LatLng(14.345684, 120.924672),
        const gmaps.LatLng(14.345489, 120.924708),
        const gmaps.LatLng(14.345219, 120.924734),
        const gmaps.LatLng(14.344801, 120.924987),
        const gmaps.LatLng(14.344346, 120.925175),
        const gmaps.LatLng(14.344213, 120.925246),
        const gmaps.LatLng(14.344008, 120.925475),
        const gmaps.LatLng(14.343798, 120.925880),
        const gmaps.LatLng(14.343625, 120.926105),
        const gmaps.LatLng(14.341674, 120.927426),
        const gmaps.LatLng(14.339827, 120.928476),
        const gmaps.LatLng(14.338995, 120.928771),
        const gmaps.LatLng(14.336666, 120.929474),
        const gmaps.LatLng(14.330096, 120.932412),
        const gmaps.LatLng(14.328797, 120.933384),
        const gmaps.LatLng(14.328467, 120.932955),
        const gmaps.LatLng(14.327900, 120.933625),
        const gmaps.LatLng(14.326806, 120.934780),
      ],
      fareMatrices: [
        'assets/fareMtrix.jpg'
      ],
      puvType: 'Jeepney', // Add this line
      landmarks: [
        'Jollibee Bucandala',
        'Imus Institute of Science and Technology',
        'Alapan Elementary School'
      ],
    ),

    TricycleTerminal(name: 'Lumina Van Terminal(Imus to Alabang)',
      location: const gmaps.LatLng(14.424081624991894, 120.9413363934624),
      route: [
        const gmaps.LatLng(14.422289, 120.941887),
        const gmaps.LatLng(14.422275, 120.941938),
        const gmaps.LatLng(14.422206, 120.941920),
        const gmaps.LatLng(14.421806, 120.941717),
        const gmaps.LatLng(14.421713, 120.941704),
        const gmaps.LatLng(14.420922, 120.941410),
        const gmaps.LatLng(14.420383, 120.941275),
        const gmaps.LatLng(14.419662, 120.941145),
        const gmaps.LatLng(14.416388, 120.940995),
        const gmaps.LatLng(14.414374, 120.940884),
        const gmaps.LatLng(14.414019, 120.940848),
        const gmaps.LatLng(14.411415, 120.940743),
        const gmaps.LatLng(14.411101, 120.940719),
        const gmaps.LatLng(14.406543, 120.940498),// patindig cross section
        const gmaps.LatLng(14.405393, 120.940407),
        const gmaps.LatLng(14.404162, 120.940342),
        const gmaps.LatLng(14.401981, 120.940262),
        const gmaps.LatLng(14.401932, 120.940231),
        const gmaps.LatLng(14.401155, 120.940193),
        const gmaps.LatLng(14.400816, 120.940060),
        const gmaps.LatLng(14.400549, 120.940051),
        const gmaps.LatLng(14.399635, 120.939994),
        const gmaps.LatLng(14.398685, 120.939957),
        const gmaps.LatLng(14.395287, 120.939793),
        const gmaps.LatLng(14.394634, 120.939868),
        const gmaps.LatLng(14.392117, 120.939747),
        const gmaps.LatLng(14.389688, 120.939612),
        const gmaps.LatLng(14.389547, 120.939616),
        const gmaps.LatLng(14.386287, 120.939450),
        const gmaps.LatLng(14.385945, 120.939422),
        const gmaps.LatLng(14.382352, 120.939246),
        const gmaps.LatLng(14.379947, 120.939127),
        const gmaps.LatLng(14.377076, 120.938981),
        const gmaps.LatLng(14.371586, 120.938742),
        const gmaps.LatLng(14.372882, 120.940786),
        const gmaps.LatLng(14.373054, 120.941188),
        const gmaps.LatLng(14.373127, 120.941717),
        const gmaps.LatLng(14.373168, 120.943042),
        const gmaps.LatLng(14.373314, 120.943444),
        const gmaps.LatLng(14.374961, 120.945595),
        const gmaps.LatLng(14.375335, 120.946137),
        const gmaps.LatLng(14.377879, 120.952985),
        const gmaps.LatLng(14.378206, 120.953508),
        const gmaps.LatLng(14.381789, 120.957585),
        const gmaps.LatLng(14.385827, 120.960396),
        const gmaps.LatLng(14.386294, 120.960913),
        const gmaps.LatLng(14.388121, 120.964631),
        const gmaps.LatLng(14.388731, 120.967007),
        const gmaps.LatLng(14.388765, 120.967530),
        const gmaps.LatLng(14.388749, 120.968442),
        const gmaps.LatLng(14.388326, 120.969840),
        const gmaps.LatLng(14.387944, 120.970462),
        const gmaps.LatLng(14.386835, 120.974590),
        const gmaps.LatLng(14.386364, 120.976307),
        const gmaps.LatLng(14.385933, 120.977900),
        const gmaps.LatLng(14.385808, 120.979206),
        const gmaps.LatLng(14.385618, 120.979557),
        const gmaps.LatLng(14.385473, 120.979694),
        const gmaps.LatLng(14.383418, 120.980432),
        const gmaps.LatLng(14.383522, 120.983752),
        const gmaps.LatLng(14.383428, 120.984528),
        const gmaps.LatLng(14.381913, 120.987888),
        const gmaps.LatLng(14.381759, 120.989766),
        const gmaps.LatLng(14.380578, 120.991529),
        const gmaps.LatLng(14.380708, 120.994485),
        const gmaps.LatLng(14.380648, 120.994721),
        const gmaps.LatLng(14.379680, 120.996204),
        const gmaps.LatLng(14.375901, 120.998938),
        const gmaps.LatLng(14.375397, 120.999534),
        const gmaps.LatLng(14.375021, 121.000169),
        const gmaps.LatLng(14.374472, 121.002621),
        const gmaps.LatLng(14.374667, 121.004354),
        const gmaps.LatLng(14.374688, 121.011367),
        const gmaps.LatLng(14.374831, 121.012188),
        const gmaps.LatLng(14.374673, 121.012435),
        const gmaps.LatLng(14.374454, 121.012537),
        const gmaps.LatLng(14.374210, 121.012523),
        const gmaps.LatLng(14.373696, 121.012341),
        const gmaps.LatLng(14.373410, 121.012370),
        const gmaps.LatLng(14.373199, 121.012580),
        const gmaps.LatLng(14.373202, 121.013457),
        const gmaps.LatLng(14.373316, 121.013744),
        const gmaps.LatLng(14.373675, 121.013945),
        const gmaps.LatLng(14.374080, 121.014047),
        const gmaps.LatLng(14.374610, 121.014108),
        const gmaps.LatLng(14.374891, 121.014129),
        const gmaps.LatLng(14.375845, 121.013743),
        const gmaps.LatLng(14.376133, 121.013493),
        const gmaps.LatLng(14.376393, 121.013204),
        const gmaps.LatLng(14.376962, 121.013051),
        const gmaps.LatLng(14.379721, 121.013542),
        const gmaps.LatLng(14.379963, 121.013536),
        const gmaps.LatLng(14.380397, 121.013432),
        const gmaps.LatLng(14.384860, 121.010446),
        const gmaps.LatLng(14.391677, 121.009299),
        const gmaps.LatLng(14.396834, 121.010890),
        const gmaps.LatLng(14.398996, 121.011665),
        const gmaps.LatLng(14.400222, 121.011858),
        const gmaps.LatLng(14.402144, 121.012059),
        const gmaps.LatLng(14.405089, 121.012320),
        const gmaps.LatLng(14.405692, 121.011848),
        const gmaps.LatLng(14.406157, 121.011816),
        const gmaps.LatLng(14.406536, 121.011877),
        const gmaps.LatLng(14.406889, 121.011990),
        const gmaps.LatLng(14.413896, 121.016492),
        const gmaps.LatLng(14.414166, 121.017028),
        const gmaps.LatLng(14.414369, 121.017369),
        const gmaps.LatLng(14.422609, 121.022389),
        const gmaps.LatLng(14.423389, 121.022344),
        const gmaps.LatLng(14.423945, 121.022462),
        const gmaps.LatLng(14.424360, 121.022537),
        const gmaps.LatLng(14.427499, 121.022295),
        const gmaps.LatLng(14.427831, 121.022413),
        const gmaps.LatLng(14.426386, 121.027225),
        const gmaps.LatLng(14.424926, 121.030577),
        const gmaps.LatLng(14.424371, 121.031790),
        const gmaps.LatLng(14.423791, 121.033707),
        const gmaps.LatLng(14.422820, 121.036663),
        const gmaps.LatLng(14.422623, 121.037409),
        const gmaps.LatLng(14.422460, 121.038523),
        const gmaps.LatLng(14.422430, 121.039278),
        const gmaps.LatLng(14.422454, 121.041944),
        const gmaps.LatLng(14.422360, 121.042132),

      ],
      fareMatrices: [
        'assets/fareMtrix.jpg'
      ],
      puvType: 'Van', // Add this line
      landmarks: [
        'Jollibee Bucandala',
        'Imus Institute of Science and Technology',
        'Alapan Elementary School'
      ],
    ),

  ];
  // Getter to expose the terminals list
  List<TricycleTerminal> get terminals => _terminals;
  void addTerminal(TricycleTerminal terminal) {
    _terminals.add(terminal);
    notifyListeners();
  }


}





