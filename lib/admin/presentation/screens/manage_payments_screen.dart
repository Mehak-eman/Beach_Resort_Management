import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/admin_payment_view_model.dart';

class ManagePaymentScreen extends StatefulWidget {
  const ManagePaymentScreen({
    super.key,
  });

  @override
  State<ManagePaymentScreen> createState() =>
      _ManagePaymentScreenState();
}

class _ManagePaymentScreenState
    extends State<ManagePaymentScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AdminPaymentViewModel>()
          .loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Manage Payments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<AdminPaymentViewModel>()
                  .loadPayments();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: Consumer<AdminPaymentViewModel>(
        builder: (
          context,
          provider,
          child,
        ) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(20),

                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Text(
                      provider.errorMessage!,
                      textAlign:
                          TextAlign.center,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    ElevatedButton(
                      onPressed: () {
                        provider
                            .loadPayments();
                      },
                      child: const Text(
                        'Retry',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.payments.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  Icon(
                    Icons.payment_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Text(
                    'No payments found.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh:
                provider.loadPayments,

            child: ListView.builder(
              padding:
                  const EdgeInsets.all(16),

              itemCount:
                  provider.payments.length,

              itemBuilder:
                  (context, index) {
                final payment =
                    provider.payments[index];

                return _paymentCard(
                  payment,
                );
              },
            ),
          );
        },
      ),
    );
  }


  // PAYMENT CARD
  

  Widget _paymentCard(
    Map<String, dynamic> payment,
  ) {
    final paymentId =
        payment['id']?.toString() ?? '-';

    final bookingId =
        payment['booking_id']?.toString() ??
            '-';

    final userId =
        payment['user_id']?.toString() ??
            '-';

    final amount =
        payment['amount']?.toString() ??
            '0';

    final method =
        payment['payment_method']
                ?.toString() ??
            'Unknown';

    final status =
        payment['payment_status']
                ?.toString() ??
            'Pending';

    final createdAt =
        payment['created_at']
                ?.toString() ??
            '-';

    final isPaid =
        status.toLowerCase() == 'paid';

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),

      elevation: 2,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
       
            // TOP ROW
           

            Row(
              children: [
                CircleAvatar(
                  radius: 24,

                  backgroundColor:
                      isPaid
                          ? Colors.green
                              .withOpacity(
                              0.12,
                            )
                          : Colors.orange
                              .withOpacity(
                              0.12,
                            ),

                  child: Icon(
                    Icons.payment,
                    color: isPaid
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Text(
                        'Payment #$paymentId',

                        style:
                            const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        'Booking #$bookingId',

                        style:
                            const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                _statusBadge(
                  status,
                ),
              ],
            ),

            const Divider(
              height: 30,
            ),

          
            // PAYMENT INFORMATION
           

            _infoRow(
              Icons.person,
              'User ID',
              userId,
            ),

            const SizedBox(
              height: 10,
            ),

            _infoRow(
              Icons.attach_money,
              'Amount',
              '\$$amount',
            ),

            const SizedBox(
              height: 10,
            ),

            _infoRow(
              Icons.credit_card,
              'Payment Method',
              method,
            ),

            const SizedBox(
              height: 10,
            ),

            _infoRow(
              Icons.calendar_today,
              'Created At',
              createdAt,
            ),
          ],
        ),
      ),
    );
  }

  
  // INFO ROW


  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.blue,
        ),

        const SizedBox(
          width: 10,
        ),

        Text(
          '$title: ',
          style: const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        Expanded(
          child: Text(
            value,
            overflow:
                TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }


  // STATUS BADGE


  Widget _statusBadge(
    String status,
  ) {
    final isPaid =
        status.toLowerCase() ==
            'paid';

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: isPaid
            ? Colors.green
                .withOpacity(0.12)
            : Colors.orange
                .withOpacity(0.12),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: isPaid
              ? Colors.green
              : Colors.orange,

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}