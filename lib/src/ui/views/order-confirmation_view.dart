import 'package:flutter/material.dart';
import 'package:haweyati/l10n/app_localizations.dart';
import 'package:haweyati/src/rest/_new/auth_service.dart';
import 'package:haweyati/src/ui/modals/dialogs/order/unable-to-place-order_dialog.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/pages/auth/sign-in_page.dart';
import 'package:haweyati/src/ui/pages/orders/order-placed_page.dart';
import 'package:haweyati/src/ui/pages/payment/payment-methods_page.dart';
import 'package:haweyati/src/ui/snack-bars/payment/not-selected_snack-bar.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';
import 'package:haweyati/src/ui/widgets/details-table.dart';
import 'package:haweyati/src/ui/widgets/table-rows.dart';
import 'package:haweyati/src/utils/navigator.dart';
import 'package:haweyati/src/utils/phone-verification.dart';
import 'package:haweyati_client_data_models/data.dart';

import 'header_view.dart';
import 'order-location_view.dart';

typedef OrderConfirmationBuilder<T extends OrderableProduct> = List<Widget>
    Function(AppLocalizations, Order<T>);

class OrderConfirmationView<T extends OrderableProduct>
    extends StatelessWidget {
  final Order<T> order;
  final OrderConfirmationBuilder<T> itemsBuilder;
  final OrderConfirmationBuilder<T> pricingBuilder;

  OrderConfirmationView({
    @required this.order,
    @required this.itemsBuilder,
    @required this.pricingBuilder,
  })  : assert(order != null),
        assert(itemsBuilder != null),
        assert(pricingBuilder != null);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    final items = itemsBuilder(lang, order);
    final pricing = pricingBuilder(lang, order);

    return ScrollableView(
      key: _scaffoldKey,
      appBar: HaweyatiAppBar(progress: .75, confirmOrderCancel: true),
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
      showBackground: true,
      children: [
        HeaderView(
          title: lang.orderConfirmationPageTitle,
          subtitle: lang.orderConfirmationPageSubtitle,
        ),
        ...items,
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: OrderLocationView(
            location: order.location,
            onEdit: Navigator.of(context).pop,
          ),
        ),
        ...pricing,
        DetailsTable([
          PriceRow('Subtotal', order.subtotal),
        ]),
        Divider(),
        DetailsTable([
          PercentRow('Value Added Tax (VAT)', Order.vat),
          TotalPriceRow(order.total)
        ])
      ],
      bottom: RaisedActionButton(
        label: 'Proceed',
        onPressed: () async {
          final _appData = AppData();
          if (!_appData.isAuthenticated) {
            /// Verify guest user;
            final contact = "+923006309211";
            final profile = await AuthService.getProfile(contact);

            if (profile.hasScope('customer')) {
              if (!profile.isGuest) {
                await navigateTo(context, SignInPage());
              }
            }
            // final contact = await getVerifiedPhoneNumber(context);
            // print(contact);
            return;
            // await navigateTo(context, SignInPage());

            if (!_appData.isAuthenticated) return;
          }

          order.customer = AppData().user;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // if (preProcess != null) await preProcess();

          final result = await navigateTo(
            context,
            PaymentMethodPage(
              amount: order.total.toInt(),
            ),
          );

          if (result == null) {
            _scaffoldKey.currentState
                .showSnackBar(PaymentMethodNotSelectedSnackBar());
            return;
          }

          order.payment = OrderPayment(
            type: result.method,
            intentId: result.intentId,
          );

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => WaitingDialog(message: 'Placing your order'),
          );

          try {
            var _service;
            //= OrdersService();
            final _order = await _service.$placeOrder(order);

            // _order.images = [];
            // for (final image in order.images) {
            //   print(_order.id);
            //   _order.images.add(OrderImage(
            //     sort: 'loc',
            //     name: await _service.addImage(
            //       _order.id,
            //       image.sort,
            //       image.name,
            //     ),
            //   ));
            // }

            Navigator.of(context).pop();
            navigateTo(context, OrderPlacedPage(_order, () async {}));
          } catch (e) {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => UnableToPlaceOrderDialog(e),
            );
          }
        },
      ),
    );
  }
}
