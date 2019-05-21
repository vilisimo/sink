import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const ICON_SIZE = 20.0;
const ICON_BACKGROUND_SIZE = 36.0;

final LinkedHashMap<String, IconData> icons = {
  // Generic
  "add": Icons.add,

  // Vehicles
  "bicycle": FontAwesomeIcons.bicycle,
  "car": Icons.directions_car,
  "car2": FontAwesomeIcons.car,
  "bus": FontAwesomeIcons.busAlt,
  "motorcycle": FontAwesomeIcons.motorcycle,
  "gas_pump": FontAwesomeIcons.gasPump,
  "charging_station": FontAwesomeIcons.chargingStation,
  "tractor": FontAwesomeIcons.tractor,

  // Computers & electronics
  "gamepad": FontAwesomeIcons.gamepad,
  "gamepad_retro": Icons.videogame_asset,
  "laptop_apple": Icons.laptop_mac,
  "laptop_windows": Icons.laptop_windows,
  "desktop_apple": Icons.desktop_mac,
  "desktop_windows": Icons.desktop_windows,
  "phone_android": Icons.phone_android,
  "phone_apple": Icons.phone_iphone,
  "server": FontAwesomeIcons.server,
  "tablet_android": Icons.tablet_android,
  "tablet_apple": Icons.tablet_mac,
  "tv": Icons.tv,
  "watch": Icons.watch,

  // Clothes
  "tshirt": FontAwesomeIcons.tshirt,

  // Food & drink
  "food": Icons.fastfood,
  "restaurant": Icons.restaurant,
  "beer": FontAwesomeIcons.beer,
  "birthday_cake": FontAwesomeIcons.birthdayCake,
  "candy": FontAwesomeIcons.candyCane,
  "cocktail": FontAwesomeIcons.cocktail,
  "glass_martini": FontAwesomeIcons.glassMartiniAlt,
  "wine_glass": FontAwesomeIcons.wineGlassAlt,
  "glass_whiskey": FontAwesomeIcons.glassWhiskey,
  "wine_bottle": FontAwesomeIcons.wineBottle,
  "coffee": FontAwesomeIcons.coffee,
  "cookie": FontAwesomeIcons.cookie,
  "egg": FontAwesomeIcons.egg,
  "fish": FontAwesomeIcons.fish,
  "hotdog": FontAwesomeIcons.hotdog,
  "icecream": FontAwesomeIcons.iceCream,
  "lemon": FontAwesomeIcons.lemon,
  "mortar_pestle": FontAwesomeIcons.mortarPestle,

  // Sports
  "basketball": FontAwesomeIcons.basketballBall,
  "baseball": FontAwesomeIcons.baseballBall,
  "bowling": FontAwesomeIcons.bowlingBall,
  "football": FontAwesomeIcons.footballBall,
  "futbal": FontAwesomeIcons.futbol,
  "golfball": FontAwesomeIcons.golfBall,
  "chess": FontAwesomeIcons.chess,
  "skating": FontAwesomeIcons.skating,
  "skiing": FontAwesomeIcons.skiing,
  "skiing_nordic": FontAwesomeIcons.skiingNordic,
  "snowboarding": FontAwesomeIcons.snowboarding,

  // Shopping & currency
  "bitcoin": FontAwesomeIcons.bitcoin,
  "ethereum": FontAwesomeIcons.ethereum,
  "gifts": FontAwesomeIcons.gifts,
  "gift": FontAwesomeIcons.gift,
  "money": Icons.attach_money,
  "money_bill": FontAwesomeIcons.moneyBill,
  "shopping_cart": Icons.local_grocery_store,
  "store": Icons.store,
  "shopping_basket": FontAwesomeIcons.shoppingBasket,

  // Travel & sightseeing
  "binoculars": FontAwesomeIcons.binoculars,
  "briefcase": FontAwesomeIcons.briefcase,
  "camera": FontAwesomeIcons.cameraRetro,
  "fly": FontAwesomeIcons.fly,
  "hotel": FontAwesomeIcons.hotel,
  "mountains": Icons.terrain,
  "plane": FontAwesomeIcons.plane,
  "spa": FontAwesomeIcons.spa,
  "suitcase": FontAwesomeIcons.suitcaseRolling,
  "taxi": FontAwesomeIcons.taxi,
  "train": Icons.train,
  "tram": Icons.tram,

  // Health & beauty
  "bath": FontAwesomeIcons.bath,
  "briefcase_medical": FontAwesomeIcons.briefcaseMedical,
  "flask": FontAwesomeIcons.flask,
  "heartbeat": FontAwesomeIcons.heartbeat,
  "heart": FontAwesomeIcons.heart,
  "solid_heart": FontAwesomeIcons.solidHeart,
  "medkit": FontAwesomeIcons.medkit,
  "microscope": FontAwesomeIcons.microscope,
  "prescription_bottle": FontAwesomeIcons.prescriptionBottleAlt,

  // Religion
  "curch": FontAwesomeIcons.church,
  "cross": FontAwesomeIcons.cross,

  // House
  "couch": FontAwesomeIcons.couch,
  "open_box": FontAwesomeIcons.boxOpen,
  "paint_roller": FontAwesomeIcons.paintRoller,
  "palette": FontAwesomeIcons.palette,
  "spray_can": FontAwesomeIcons.sprayCan,
  "toolbox": FontAwesomeIcons.toolbox,
  "tools": FontAwesomeIcons.tools,
  "trash": FontAwesomeIcons.trashAlt,

  // Other
  "bone": FontAwesomeIcons.bone,
  "concierge": FontAwesomeIcons.conciergeBell,
  "dog": FontAwesomeIcons.dog,
  "pets": Icons.pets,
  "graduation_cap": FontAwesomeIcons.graduationCap,
  "tree": FontAwesomeIcons.tree,
  "child": Icons.child_friendly,
} as LinkedHashMap<String, IconData>;
