import 'package:fluent_ui/fluent_ui.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:take_order_app/main.dart';

import '../../../customer/data/model/customer_model.dart';

class SelectCustomerPage extends StatefulWidget {
  final TextEditingController customerController;
  final GlobalKey<FormState> formKeyCustomer;
  final List<CustomerModel> lstCustomers;
  final int selectedCustomerId;
  Function(int) onSelected;
  SelectCustomerPage(
      {super.key,
      required this.customerController,
      required this.formKeyCustomer,
      required this.lstCustomers,
      required this.selectedCustomerId,
      required this.onSelected});

  @override
  State<SelectCustomerPage> createState() => _SelectCustomerPageState();
}

class _SelectCustomerPageState extends State<SelectCustomerPage> {
  final customerKey = GlobalKey<AutoSuggestBoxState>(
    debugLabel: 'Manually controlled AutoSuggestBox',
  );

  // focus node to knoz if the widget is focused
  FocusNode focusNode = FocusNode(
    debugLabel: 'Manually controlled AutoSuggestBox',
  );

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    // add listener to focusNode
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500),
            () => customerKey.currentState?.showOverlay());
      }
    });
/*
    customerKey.currentState?.showOverlay();
*/
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: widget.formKeyCustomer,
        child: Column(
          children: [
            AutoSuggestBox.form(
              key: customerKey,
              focusNode: focusNode,

              noResultsFoundBuilder: (context) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'No results found',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
              // Listen to the overlay visibility changes
              onOverlayVisibilityChanged: (visible) {
                if (visible) {
                  // The overlay is visible
                } else {
                  // The overlay is not visible
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.customerController,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                // check if selectedCustomerId is in lstCustomers
                (value) {
                  if (widget.selectedCustomerId == -1) {
                    return 'Please select a customer';
                  }
                  return null;
                }
              ]),
              onSelected: (value) {
                widget.onSelected(value.value!);
              },
              onChanged: (value, reason) {
                print(value);
                print(reason);

                /*if (reason == TextChangedReason.suggestionChosen) {
                            setState(() {
                              selectedCustomerId = int.parse(value);
                            });
                          }*/
              },
              placeholder: TranslationHelper(context: context)
                  .getTranslation('selectCustomer'),
              items: List.generate(
                widget.lstCustomers.length,
                (index) => AutoSuggestBoxItem<int>(
                    label:
                        '${widget.lstCustomers[index].fName} ${widget.lstCustomers[index].lName}',
                    value: widget.lstCustomers[index].id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
