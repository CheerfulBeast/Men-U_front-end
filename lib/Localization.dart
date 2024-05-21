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
  String? addtocart = '';
  String? step0 = '';
  String? step1 = '';
  String? step2 = '';
  String? step3 = '';
  String? step4 = '';
  String? step5 = '';
  String? step6 = '';
  String? step7 = '';
  String? receipt = '';
  String? purchased = '';
  String? empty = '';
  String? ready = '';
  String? remove = '';
  String? wait = '';
  String? checkout = '';

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
        addtocart = '加入购物车';
        step1 = '您的订单正在排队中';
        step2 = '您的订单已被确认';
        step3 = '您的食物正在烹饪';
        step4 = '您的食物正在上菜';
        receipt = '收据';
        purchased = '已购买';
        empty = '订单为空';
        ready = '准备付款了吗？';
        remove = '订单项已被移除';
        wait = '请等待付款';
        step7 = '食物已上桌';
        checkout = '结账';
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
        addtocart = 'Ajouter au panier';
        step0 = 'Votre commande est en attente';
        step1 = "Votre commande est en file d'attente";
        step2 = 'Votre commande est confirmée';
        step3 = 'Votre nourriture est en train de cuire.';
        step4 = "Votre nourriture est en train d'être servie";
        receipt = 'Reçu';
        purchased = 'Acheté';
        empty = 'Les commandes sont vides';
        ready = 'Prêt à payer ?';
        remove = "L'article de la commande a été supprimé";
        wait = 'Veuillez attendre le paiement';
        step7 = 'La nourriture est servie';
        checkout = 'Caisse';
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
        addtocart = 'In den Warenkorb';
        step1 = 'Ihre Bestellung ist in der Warteschlange';
        step2 = 'Ihre Bestellung ist bestätigt';
        step3 = 'Ihr Essen wird zubereitet.';
        step4 = "Ihr Essen wird serviert.";
        receipt = 'Quittung';
        purchased = 'Gekauft';
        empty = 'Bestellungen sind leer';
        ready = 'Bereit zu zahlen?';
        remove = 'Bestellartikel wurde entfernt';
        wait = 'Bitte warten Sie auf die Zahlung';
        step7 = 'Das Essen wird serviert';
        checkout = 'Kasse';
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
        addtocart = 'Añadir al carrito';
        step1 = 'Su pedido está en la cola';
        step2 = 'Su pedido ha sido confirmado';
        step3 = 'Tu comida se está cocinando.';
        step4 = "Tu comida se está sirviendo.";
        receipt = 'Recibo';
        purchased = 'Comprado';
        empty = 'Los pedidos están vacíos';
        ready = '¿Listo para pagar?';
        remove = 'El artículo del pedido ha sido eliminado';
        wait = 'Por favor, espere para el pago';
        step7 = 'La comida está servida';
        checkout = 'Pagar';
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
        addtocart = 'Add to Cart';
        step1 = 'Your order is on queue';
        step2 = 'Your order is acknowledged';
        step3 = 'Your food is cooking';
        step4 = "Your food is being served";
        receipt = 'Receipt';
        purchased = 'Purchased';
        empty = 'Orders is empty';
        ready = 'Ready to Pay?';
        remove = 'Order item has been removed';
        wait = 'Waiting for Payment';
        step7 = 'Food is served';
        checkout = 'Checkout';
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
        addtocart = 'Add to Cart';
        step1 = 'Your order is on queue';
        step2 = 'Your order is acknowledged';
        step3 = 'Your food is cooking';
        step4 = "Your food is being served";
        receipt = 'Receipt';
        purchased = 'Purchased';
        empty = 'Orders is empty';
        ready = 'Ready to Pay?';
        remove = 'Order item has been removed';
        wait = 'Please Wait for Payment';
        step7 = 'Food is served';
        checkout = 'Checkout';
        break;
    }
  }
}
