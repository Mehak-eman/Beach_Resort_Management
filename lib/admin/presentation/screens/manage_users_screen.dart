import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/admin_user_view_model.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({
    super.key,
  });

  @override
  State<ManageUsersScreen> createState() =>
      _ManageUsersScreenState();
}

class _ManageUsersScreenState
    extends State<ManageUsersScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AdminUserViewModel>()
          .loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<AdminUserViewModel>()
                  .loadUsers();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: Consumer<AdminUserViewModel>(
        builder: (
          context,
          provider,
          child,
        ) {
          if (provider.isLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
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
                      color: Colors.red,
                      size: 60,
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
                      onPressed:
                          provider.loadUsers,
                      child:
                          const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.users.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  Icon(
                    Icons.people_outline,
                    size: 70,
                    color: Colors.grey,
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Text(
                    'No users found.',
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
                provider.loadUsers,

            child: ListView.builder(
              padding:
                  const EdgeInsets.all(16),

              itemCount:
                  provider.users.length,

              itemBuilder:
                  (context, index) {
                final user =
                    provider.users[index];

                return _userCard(
                  user,
                  provider,
                );
              },
            ),
          );
        },
      ),
    );
  }

  
  // USER CARD
  

  Widget _userCard(
    Map<String, dynamic> user,
    AdminUserViewModel provider,
  ) {
    final userId =
        user['id']?.toString() ?? '';

    final name =
        user['name']?.toString() ??
            'Unknown User';

    final email =
        user['email']?.toString() ??
            'No email';

    final phone =
        user['phone']?.toString() ??
            'No phone';

    final avatarUrl =
        user['avatar_url']?.toString();

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      elevation: 2,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(14),

        child: Row(
          children: [
            
            // PROFILE IMAGE
           

            CircleAvatar(
              radius: 30,

              backgroundColor:
                  Colors.blue.shade100,

              backgroundImage:
                  avatarUrl != null &&
                          avatarUrl.isNotEmpty
                      ? NetworkImage(
                          avatarUrl,
                        )
                      : null,

              child: avatarUrl == null ||
                      avatarUrl.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.blue,
                    )
                  : null,
            ),

            const SizedBox(
              width: 14,
            ),

            
            // USER INFORMATION
           

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    email,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    phone,
                    style:
                        const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

         
            // DELETE
          

            IconButton(
              onPressed: provider.isDeleting
                  ? null
                  : () {
                      _confirmDelete(
                        userId,
                        name,
                      );
                    },

              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // DELETE CONFIRMATION
  

  void _confirmDelete(
    String userId,
    String name,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete User',
          ),

          content: Text(
            'Are you sure you want to delete "$name"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text('Cancel'),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),

              onPressed: () async {
                final provider =
                    context.read<
                        AdminUserViewModel>();

                final success =
                    await provider
                        .deleteUser(
                  userId,
                );

                if (!mounted) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'User deleted successfully.'
                          : provider
                                  .errorMessage ??
                              'Failed to delete user.',
                    ),
                  ),
                );
              },

              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}