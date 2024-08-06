import 'package:home_service_provider/app/models/model_address.dart';
import 'package:home_service_provider/app/models/model_booking.dart';
import 'package:home_service_provider/app/models/model_card.dart';
import 'package:home_service_provider/app/models/model_cart.dart';
import 'package:home_service_provider/app/models/model_category.dart';
import 'package:home_service_provider/app/models/model_color.dart';
import 'package:home_service_provider/app/models/model_country.dart';
import 'package:home_service_provider/app/models/model_intro.dart';
import 'package:home_service_provider/app/models/model_notification.dart';
import 'package:home_service_provider/app/models/model_other.dart';
import 'package:home_service_provider/app/models/model_popular_service.dart';
import 'package:home_service_provider/app/models/model_salon.dart';

import '../../base/color_data.dart';

class DataFile {
  static List<ModelIntro> introList = [
    ModelIntro(
        1,
        "Digital Pick List",
        "Order details are automatically assigned and sent to each picker, where they can follow instructions on their device for a more efficient process.",
        "intro5.png",
        intro1Color),
    ModelIntro(
        2,
        "Smart Devices for Picking",
        "Smart devices equipped with mobile computer vision software are a more efficient and intuitive choice to optimize the in-store order picking process.",
        "intro6.png",
        intro2Color),
    ModelIntro(
        3,
        "Order Picking Checklist",
        "By digitalizing your checklists to perform audits, you can be instantly notified of missed time targets. ",
        "intro1.png",
        intro3Color),
  ];

  static List<ModelCountry> countryList = [
    ModelCountry("image_fghanistan.jpg", "Afghanistan (AF)", "+93"),
    ModelCountry("image_ax.jpg", "Aland Islands (AX)", "+358"),
    ModelCountry("image_albania.jpg", "Albania (AL)", "+355"),
    ModelCountry("image_andora.jpg", "Andorra (AD)", "+376"),
    ModelCountry("image_islands.jpg", "Aland Islands (AX)", "+244"),
    ModelCountry("image_angulia.jpg", "Anguilla (AL)", "+1"),
    ModelCountry("image_armenia.jpg", "Armenia (AN)", "+374"),
    ModelCountry("image_austia.jpg", "Austria (AT)", "+372"),
  ];

  static List<ModelCategory> categoryList = [
    ModelCategory("location-map.svg", "Local","1"),
    ModelCategory("truck.svg", "Booking", "1")
  ];
  static List<ModelCategory> categoryList2 = [
    ModelCategory("delivery-motorbike.svg", "Courier","1"),
    ModelCategory("town.svg", "Town", "1"),
  ];

  static List<ModelItem> itemProductList = [
    ModelItem("Item Code #1", "Item Description 1#", "0 Items Pending ","10 Items Completed ", 10.00, 0),
    ModelItem("Item Code #2", "Item Description 2#", "9 Items Pending ","1 Items Completed", 8.00, 0),
    ModelItem("Item Code #3", "Item Description 3#", "15 Items Pending ","0 Items Completed", 12.00, 0),

  ];

  static List<ModelColor> hairColorList = [
    ModelColor("blackhair.png", "Black", "Black Hair Color", "4.5", 6.00, 0),
    ModelColor("brownhair.png", "Brown", "Brown Hair Color", "4.5", 10.00, 0),
  ];

  static Map<String, ModelCart> cartList = {};

  static List<ModelOther> otherProductList = [
    ModelOther("beard_shape.png", "Beard Shaping", 13.00, 0),
    ModelOther("head_massage.png", "Head Massage", 16.00, 0),
  ];

  static List<String> timeList = [
    "06:00 AM",
    "08:00 AM",
    "10:00 AM",
    "12:00 PM",
    "13:00 PM",
    "14:00 PM",
    "16:00 PM",
    "18:00 PM",
    "19:00 PM",
    "20:00 PM",
    "21:00 PM"
  ];

  static List<ModelCard> cardList = [
    ModelCard("paypal.svg", "Paypal", "xxxx xxxx xxxx 5416"),
    ModelCard("mastercard.svg", "Master Card", "xxxx xxxx xxxx 8624"),
    ModelCard("visa.svg", "Visa", "xxxx xxxx xxxx 4565")
  ];

  static List<ModelBooking> bookingList = [
    ModelBooking("Pick #1", "23 Nov, 2022, 11:00 am", "120 Items",
        20675.00, "Customer Name 1", "Active", 0xFFEEFCF0, success),
    ModelBooking("Pick #2", "23 Nov, 2022, 08:00 am", "98 Items",
        50.00, "Customer Name 2", "Completed", 0xFFF0F8FF, completed),
    ModelBooking( "PI1008", "23 Nov, 2022, 06:00 pm", "52 Items",
        18.00, "Customer Name 3", "Cancelled", 0xFFFFF3F3, error),
    ModelBooking("Pick #4", "23 Nov, 2022, 06:00 pm", "43 Items",
        18.00, "Customer Name 4", "Completed", 0xFFF0F8FF, completed),
  ];

/*
  static List<AssignedPickList> assignedPickList = [
    AssignedPickList("120 Items","Pick #1","231", "23 Nov, 2022, 11:00 am",
         "Customer Name 1","Customer Code","11:00 am","23 Nov, 2022, 11:00 am", "Test","Active", 20675.00, 0xFFEEFCF0, success),
  ];
  */

  static List<ModelBooking> scheduleList = [
    ModelBooking( "Pick #5", "23 Nov, 2022, 11:00 am", "147 Items",
        20.00, "Customer Name 5", "Active", 0xFFEEFCF0, success),
    ModelBooking("Pick #6", "22 Nov, 2022, 08:00 am", "59 Items",
        50.00, "Customer Name 6", "Completed", 0xFFF0F8FF, completed),
  ];

  static List<ModelAddress> addressList = [
    ModelAddress("Alena Gomez",
        "3891 Ranchview Dr. Richardson, California 62639", "(907) 555-0101"),
    ModelAddress("Alena Gomez", "4140 Parker Rd. Allentown, New Mexico 31134",
        "(907) 555-0101"),
  ];

  static List<ModelNotification> notificationList = [
    ModelNotification(
        "Lorem ipsum dolor",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed maximus congue rutrum. Morbi malesuada eleifend eros vel malesuada. Duis sed molestie purus.",
        "1 h ago",
        "Today"),
    ModelNotification(
        "Lorem ipsum dolor",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed maximus congue rutrum. Morbi malesuada eleifend eros vel malesuada. Duis sed molestie purus.",
        "1 h ago",
        "Today"),
    ModelNotification(
        "Lorem ipsum dolor",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed maximus congue rutrum. Morbi malesuada eleifend eros vel malesuada. Duis sed molestie purus.",
        "03:00 pm",
        "Yesterday"),
    ModelNotification(
        "Lorem ipsum dolor",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed maximus congue rutrum. Morbi malesuada eleifend eros vel malesuada. Duis sed molestie purus.",
        "01:00 pm",
        "Yesterday"),
  ];

  static List<String> searchList = [];

  static List<String> popularSearchList = [
    "cleaning",
    "washing",
    "painting",
    "salon",
    "health",
    "transport",
    "gardening",
    "beauty",
    "trashing",
    "plumbing"
  ];

  static List<ModelPopularService> popularServiceList = [
    ModelPopularService("checklist.jpg", "Customer Name", "Picker: Picker Name"),
    ModelPopularService("checklist.jpg", "Customer Name", "Picker: Picker Name"),
    ModelPopularService("checklist.jpg", "Customer Name", "Picker: Picker Name"),
    ModelPopularService("checklist.jpg", "Customer Name", "Picker: Picker Name"),
  ];
}
