import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/admin_view_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({
    super.key,
  });

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AdminViewModel>()
          .loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<AdminViewModel>()
                  .refreshDashboard();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: Consumer<AdminViewModel>(
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
                            .loadDashboard();
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

        
          // DASHBOARD
         

          return RefreshIndicator(
            onRefresh:
                provider.refreshDashboard,

            child: ListView(
              padding:
                  const EdgeInsets.all(20),

              children: [
                const Text(
                  'Welcome, Admin',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                const Text(
                  'Manage your beach resort application',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

              
                // STAT CARDS
           

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),

                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,

                  childAspectRatio: 1.3,

                  children: [
                    _statCard(
                      icon: Icons.people,
                      title: 'Users',
                      value:
                          provider.totalUsers,
                    ),

                    _statCard(
                      icon: Icons.hotel,
                      title: 'Resorts',
                      value:
                          provider.totalResorts,
                    ),

                    _statCard(
                      icon:
                          Icons.book_online,
                      title: 'Bookings',
                      value:
                          provider.totalBookings,
                    ),

                    _statCard(
                      icon: Icons.payment,
                      title: 'Payments',
                      value:
                          provider.totalPayments,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

               
                // PENDING
              

                const Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                _pendingCard(
                  icon:
                      Icons.pending_actions,
                  title:
                      'Pending Bookings',
                  value:
                      provider.pendingBookings,
                ),

                const SizedBox(
                  height: 12,
                ),

                _pendingCard(
                  icon:
                      Icons.money_off,
                  title:
                      'Pending Payments',
                  value:
                      provider.pendingPayments,
                ),

                const SizedBox(
                  height: 30,
                ),

                
                // ADMIN CONTROLS
            

                const Text(
                  'Admin Controls',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                // MANAGE RESORTS
               

                _menuTile(
                  icon: Icons.hotel,
                  title:
                      'Manage Resorts',
                  onTap: () {
                   context.push('/admin-resorts');
                  },
                ),

                
                // MANAGE BOOKINGS
              

                _menuTile(
                  icon:
                      Icons.book_online,
                  title:
                      'Manage Bookings',
                  onTap: () {
                    context.push(
                      '/admin-bookings',
                    );
                  },
                ),

              
                // MANAGE PAYMENTS
      

                _menuTile(
                  icon: Icons.payment,
                  title:
                      'Manage Payments',
                  onTap: () {
                  context.push('/admin-payments');
                  },
                ),

               
                // MANAGE USERS
           

                _menuTile(
                  icon: Icons.people,
                  title:
                      'Manage Users',
                  onTap: () {
                    context.push('/admin-users');
                  },
                ),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

 
  // STAT CARD
 

  Widget _statCard({
    required IconData icon,
    required String title,
    required int value,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.06),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Icon(
            icon,
            size: 32,
            color: Colors.blue,
          ),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),

          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 25,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

 
  // PENDING CARD
  

  Widget _pendingCard({
    required IconData icon,
    required String title,
    required int value,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            child: Icon(icon),
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  
  // MENU TILE
  

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),

        onTap: onTap,
      ),
    );
  }
}