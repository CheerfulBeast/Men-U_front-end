import 'package:flutter/material.dart';

class LocalizedText {
  static final LocalizedText _instance = LocalizedText._internal();

  LocalizedText._internal();

  factory LocalizedText() {
    return _instance;
  }
  // Localized Variables
  String? menu = '';
  String? all = '';
  String? categories = '';
  String? available = '';
  String? chooseLanguage = '';
  String? cart = '';
  String? grandTotal = '';
  String? continues = '';

  void translate(int language) {
    switch (language) {
      case 1:
        menu = '菜单';
        all = '全部';
        categories = '类别';
        available = '可用';
        chooseLanguage = '语言';
        cart = '购物车';
        grandTotal = '总计';
        continues = '继续';
        break;
      case 2:
        menu = 'Menu';
        all = 'Tout';
        categories = 'Catégories';
        available = 'Disponible';
        chooseLanguage = 'Langue';
        cart = 'Panier';
        grandTotal = 'Total Général';
        continues = 'Continuer';
        break;
      case 3:
        menu = 'Speisekarte';
        all = 'Alle';
        categories = 'Kategorien';
        available = 'Verfügbar';
        chooseLanguage = 'Sprache';
        cart = 'Wagen';
        grandTotal = 'Gesamtsumme';
        continues = 'Fortsetzen';
        break;
      case 4:
        menu = 'Menú';
        all = 'Todo';
        categories = 'Categorías';
        available = 'Disponible';
        chooseLanguage = 'Idioma';
        cart = 'Carrito';
        grandTotal = 'Total General';
        continues = 'Continuar';
        break;
      case 5:
        menu = 'Menu';
        all = 'All';
        categories = 'Categories';
        available = 'Available';
        chooseLanguage = 'Language';
        cart = 'Cart';
        grandTotal = 'Grand Total';
        continues = 'Continue';
        break;
      default:
        menu = 'Menu';
        all = 'All';
        categories = 'Categories';
        available = 'Available';
        chooseLanguage = 'Language';
        cart = 'Cart';
        grandTotal = 'Grand Total';
        continues = 'Continue';
        break;
    }
  }
}
