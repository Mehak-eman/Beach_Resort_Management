import 'package:beach_resort_management/admin/viewmodels/admin_booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({
    super.key,
  });

  @override
  State<ManageBookingsScreen> createState() =>
      _ManageBookingsScreenState();
}

class _ManageBookingsScreenState
    extends State<ManageBookingsScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AdminBookingViewModel>()
          .loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          "Manage Bookings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Consumer<AdminBookingViewModel>(
        builder: (
          context,
          provider,
          child,
        ) {
      
          // LOADING
     

          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

         
          // ERROR
      

          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        provider.loadBookings();
                      },
                      child: const Text(
                        "Try Again",
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

         
          // EMPTY
    

          if (provider.bookings.isEmpty) {
            return RefreshIndicator(
              onRefresh:
                  provider.loadBookings,
              child: ListView(
                children: const [
                  SizedBox(
                    height: 250,
                  ),

                  Icon(
                    Icons.calendar_month_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Center(
                    child: Text(
                      "No bookings found.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

   
          // BOOKINGS LIST
   

          return RefreshIndicator(
            onRefresh:
                provider.loadBookings,

            child: ListView.builder(
              padding:
                  const EdgeInsets.all(16),

              itemCount:
                  provider.bookings.length,

              itemBuilder:
                  (context, index) {
                final booking =
                    provider.bookings[index];

                return _bookingCard(
                  context,
                  provider,
                  booking,
                );
              },
            ),
          );
        },
      ),
    );
  }

  
  // BOOKING CARD


  Widget _bookingCard(
    BuildContext context,
    AdminBookingViewModel provider,
    Map<String, dynamic> booking,
  ) {
    final bookingId =
        booking['id']?.toString() ?? '';

    final status =
        booking['status']?.toString() ??
            'Pending';

    final user =
        booking['profiles']
            as Map<String, dynamic>?;

    final resort =
        booking['resorts']
            as Map<String, dynamic>?;

    final userName =
        user?['name']?.toString() ??
            'Unknown User';

    final userEmail =
        user?['email']?.toString() ?? '';

    final resortName =
        resort?['name']?.toString() ??
            'Unknown Resort';

    final checkIn =
        booking['check_in']?.toString() ??
            '';

    final checkOut =
        booking['check_out']?.toString() ??
            '';

    final totalPrice =
        booking['total_price'];

    final statusLower =
        status.toLowerCase();

    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

         
            // HEADER
           

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

              children: [
                Expanded(
                  child: Text(
                    "Booking #$bookingId",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                _statusBadge(
                  status,
                ),
              ],
            ),

            const Divider(
              height: 25,
            ),

          
            // USER
        

            _infoRow(
              Icons.person_outline,
              "User",
              userName,
            ),

            if (userEmail.isNotEmpty)
              _infoRow(
                Icons.email_outlined,
                "Email",
                userEmail,
              ),

            
            // RESORT
           

            _infoRow(
              Icons.hotel_outlined,
              "Resort",
              resortName,
            ),

            
            // CHECK IN
           

            _infoRow(
              Icons.login,
              "Check-in",
              checkIn,
            ),

            
            // CHECK OUT
           

            _infoRow(
              Icons.logout,
              "Check-out",
              checkOut,
            ),

          
            // PRICE
        

            _infoRow(
              Icons.attach_money,
              "Total",
              "\$$totalPrice",
            ),

            const SizedBox(
              height: 15,
            ),

            
            // ACTIONS
           

            if (statusLower == 'pending')
              Row(
                children: [

                  // REJECT
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          provider.isUpdating
                              ? null
                              : () {
                                  _updateStatus(
                                    context,
                                    provider,
                                    bookingId,
                                    "Rejected",
                                  );
                                },

                      child: const Text(
                        "Reject",
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  // APPROVE
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          provider.isUpdating
                              ? null
                              : () {
                                  _updateStatus(
                                    context,
                                    provider,
                                    bookingId,
                                    "Approved",
                                  );
                                },

                      child: const Text(
                        "Approve",
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  
  // STATUS BADGE
  

  Widget _statusBadge(
    String status,
  ) {
    Color color;

    switch (
        status.toLowerCase()) {
      case 'approved':
        color = Colors.green;
        break;

      case 'rejected':
        color = Colors.red;
        break;

      case 'completed':
        color = Colors.blue;
        break;

      default:
        color = Colors.orange;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color:
            color.withOpacity(0.12),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight:
              FontWeight.bold,
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
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 11,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            size: 21,
            color: Colors.blue,
          ),

          const SizedBox(
            width: 10,
          ),

          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
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
      ),
    );
  }

  
  // UPDATE STATUS


  Future<void> _updateStatus(
    BuildContext context,
    AdminBookingViewModel provider,
    String bookingId,
    String status,
  ) async {
    final success =
        await provider.updateBookingStatus(
      bookingId: bookingId,
      status: status,
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Booking $status successfully."
              : provider.errorMessage ??
                  "Failed to update booking.",
        ),
      ),
    );
  }
}