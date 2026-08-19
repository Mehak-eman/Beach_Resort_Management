import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/admin_resort_view_model.dart';

class ManageResortsScreen extends StatefulWidget {
  const ManageResortsScreen({
    super.key,
  });

  @override
  State<ManageResortsScreen> createState() =>
      _ManageResortsScreenState();
}

class _ManageResortsScreenState
    extends State<ManageResortsScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AdminResortViewModel>()
          .loadResorts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Manage Resorts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<AdminResortViewModel>()
                  .loadResorts();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          _showResortDialog();
        },
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Resort',
        ),
      ),

      body: Consumer<AdminResortViewModel>(
        builder: (
          context,
          provider,
          child,
        ) {
       
          // LOADING
      

          if (provider.isLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
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
                            .loadResorts();
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

          
          // EMPTY
       

          if (provider.resorts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  Icon(
                    Icons.hotel_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Text(
                    'No resorts found.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

        
          // RESORT LIST
     

          return RefreshIndicator(
            onRefresh:
                provider.loadResorts,

            child: ListView.builder(
              padding:
                  const EdgeInsets.all(16),

              itemCount:
                  provider.resorts.length,

              itemBuilder:
                  (context, index) {
                final resort =
                    provider.resorts[index];

                return _resortCard(
                  resort,
                );
              },
            ),
          );
        },
      ),
    );
  }


  // RESORT CARD


  Widget _resortCard(
    Map<String, dynamic> resort,
  ) {
    final id =
        resort['id'];

    final name =
        resort['name']?.toString() ??
            'Unnamed Resort';

    final location =
        resort['location']?.toString() ??
            'Unknown location';

    final imageUrl =
        resort['image_url']?.toString() ??
            '';

    final category =
        resort['category']?.toString() ??
            'Resort';

    final price =
        resort['price_per_night']?.toString() ??
            '0';

    final rating =
        resort['rating']?.toString() ??
            '0';

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      elevation: 3,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
        
          // IMAGE
         

          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(18),
            ),

            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,

                    height: 190,
                    width:
                        double.infinity,

                    fit: BoxFit.cover,

                    errorBuilder:
                        (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return _imagePlaceholder();
                    },
                  )
                : _imagePlaceholder(),
          ),

        
          // INFORMATION
     

          Padding(
            padding:
                const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,

                        style:
                            const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    PopupMenuButton<
                        String>(
                      onSelected:
                          (value) {
                        if (value ==
                            'edit') {
                          _showResortDialog(
                            resort: resort,
                          );
                        }

                        if (value ==
                            'delete') {
                          _deleteResort(
                            id,
                            name,
                          );
                        }
                      },

                      itemBuilder:
                          (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Edit',
                              ),
                            ],
                          ),
                        ),

                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color:
                                    Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Delete',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(
                  height: 8,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Colors.grey,
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    Expanded(
                      child: Text(
                        location,
                        style:
                            const TextStyle(
                          color:
                              Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 12,
                ),

                Row(
                  children: [
                    _infoChip(
                      Icons.category,
                      category,
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    _infoChip(
                      Icons.star,
                      rating,
                    ),

                    const Spacer(),

                    Text(
                      '\$$price/night',

                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  // IMAGE PLACEHOLDER
 

  Widget _imagePlaceholder() {
    return Container(
      height: 190,
      width: double.infinity,
      color: Colors.grey.shade300,

      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 60,
          color: Colors.grey,
        ),
      ),
    );
  }


  // INFO CHIP


  Widget _infoChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color:
            Colors.blue.withOpacity(
          0.08,
        ),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.blue,
          ),

          const SizedBox(
            width: 5,
          ),

          Text(
            text,
            style:
                const TextStyle(
              fontSize: 12,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD / EDIT DIALOG
  // ============================================================

  void _showResortDialog({
    Map<String, dynamic>? resort,
  }) {
    final isEditing =
        resort != null;

    final nameController =
        TextEditingController(
      text:
          resort?['name']?.toString() ??
              '',
    );

    final locationController =
        TextEditingController(
      text:
          resort?['location']
                  ?.toString() ??
              '',
    );

    final imageController =
        TextEditingController(
      text:
          resort?['image_url']
                  ?.toString() ??
              '',
    );

    final categoryController =
        TextEditingController(
      text:
          resort?['category']
                  ?.toString() ??
              '',
    );

    final priceController =
        TextEditingController(
      text:
          resort?['price_per_night']
                  ?.toString() ??
              '',
    );

    final ratingController =
        TextEditingController(
      text:
          resort?['rating']
                  ?.toString() ??
              '0',
    );

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isEditing
                ? 'Edit Resort'
                : 'Add Resort',
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                TextField(
                  controller:
                      nameController,
                  decoration:
                      const InputDecoration(
                    labelText: 'Resort Name',
                    prefixIcon:
                        Icon(Icons.hotel),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                TextField(
                  controller:
                      locationController,
                  decoration:
                      const InputDecoration(
                    labelText: 'Location',
                    prefixIcon:
                        Icon(
                      Icons.location_on,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                TextField(
                  controller:
                      imageController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Image URL',
                    prefixIcon:
                        Icon(Icons.image),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                TextField(
                  controller:
                      categoryController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Category',
                    prefixIcon:
                        Icon(
                      Icons.category,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                TextField(
                  controller:
                      priceController,
                  keyboardType:
                      TextInputType
                          .number,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Price Per Night',
                    prefixIcon:
                        Icon(
                      Icons.attach_money,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                TextField(
                  controller:
                      ratingController,
                  keyboardType:
                      const TextInputType
                          .numberWithOptions(
                    decimal: true,
                  ),

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Rating',
                    prefixIcon:
                        Icon(Icons.star),
                  ),
                ),
              ],
            ),
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
              onPressed: () async {
                final name =
                    nameController
                        .text
                        .trim();

                final location =
                    locationController
                        .text
                        .trim();

                final imageUrl =
                    imageController
                        .text
                        .trim();

                final category =
                    categoryController
                        .text
                        .trim();

                final price =
                    double.tryParse(
                  priceController
                      .text
                      .trim(),
                );

                final rating =
                    double.tryParse(
                  ratingController
                      .text
                      .trim(),
                );

                if (name.isEmpty ||
                    location.isEmpty ||
                    price == null ||
                    rating == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter valid resort information.',
                      ),
                    ),
                  );

                  return;
                }

                final provider =
                    context.read<
                        AdminResortViewModel>();

                bool success;

                if (isEditing) {
                  success =
                      await provider
                          .updateResort(
                     id: resort['id'],
                    name: name,
                    location:
                        location,
                    imageUrl:
                        imageUrl,
                    category:
                        category,
                    pricePerNight:
                        price,
                    rating: rating,
                  );
                } else {
                  success =
                      await provider
                          .addResort(
                    name: name,
                    location:
                        location,
                    imageUrl:
                        imageUrl,
                    category:
                        category,
                    pricePerNight:
                        price,
                    rating: rating,
                  );
                }

                if (!mounted) {
                  return;
                }

                if (success) {
                  Navigator.pop(
                    dialogContext,
                  );

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing
                            ? 'Resort updated successfully.'
                            : 'Resort added successfully.',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        provider
                                .errorMessage ??
                            'Operation failed.',
                      ),
                    ),
                  );
                }
              },

              child: Text(
                isEditing
                    ? 'Update'
                    : 'Add',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DELETE RESORT
  // ============================================================

  void _deleteResort(
    dynamic id,
    String name,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Resort',
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
                        AdminResortViewModel>();

                final success =
                    await provider
                        .deleteResort(
                  id,
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
                          ? 'Resort deleted successfully.'
                          : provider
                                  .errorMessage ??
                              'Delete failed.',
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