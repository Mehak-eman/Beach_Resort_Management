import 'dart:ui';

import 'package:beach_resort_management/home/bottom_nav_bar.dart';
import 'package:beach_resort_management/home/category_section.dart';
import 'package:beach_resort_management/home/data/featured_resort_card.dart';
import 'package:beach_resort_management/home/home_app_bar.dart';
import 'package:beach_resort_management/home/offer_banner.dart';
import 'package:beach_resort_management/home/search_bar_widget.dart';
import 'package:beach_resort_management/home/viewmodel/home_view_model.dart';
import 'package:beach_resort_management/routes/route_names.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      context
          .read<HomeViewModel>()
          .loadResorts();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'HOME SCREEN BUILD',
    );

    return Scaffold(
      backgroundColor:
          const Color(0xffF6F8FB),

     
      // BOTTOM NAVIGATION
     
      bottomNavigationBar:
          const BottomNavBar(
        currentIndex: 0,
      ),

  
      // BODY


      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          padding:
              const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
             
              // APP BAR
            

              const HomeAppBar(),

              const SizedBox(
                height: 25,
              ),

           
              // SEARCH
          

              const SearchBarWidget(),

              const SizedBox(
                height: 25,
              ),

              // OFFER
             

              const OfferBanner(),

              const SizedBox(
                height: 30,
              ),

             
              // CATEGORIES
           

              const CategorySection(),

              const SizedBox(
                height: 35,
              ),

              // FEATURED HEADER
         

              Row(
                children: [
                  const Text(
                    'Featured Resorts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const Spacer(),

                  GestureDetector(
                    behavior:
                        HitTestBehavior.opaque,

                    onTap: () {
                      context.push(
                        RouteNames.allResorts,
                      );
                    },

                    child: const Padding(
                      padding:
                          EdgeInsets.all(5),

                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Text(
                            'View All',
                            style:
                                TextStyle(
                              color:
                                  Colors.blue,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          Icon(
                            Icons
                                .arrow_forward_ios,
                            size: 14,
                            color:
                                Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              // FEATURED RESORTS
          

              Consumer<HomeViewModel>(
                builder: (
                  context,
                  provider,
                  child,
                ) {
           
                  // LOADING
                

                  if (provider.isLoading) {
                    return const SizedBox(
                      height: 380,
                      child: Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                    );
                  }

                 
                  // ERROR
                

                  if (provider.errorMessage !=
                      null) {
                    return SizedBox(
                      height: 380,
                      child: Center(
                        child: Text(
                          provider
                              .errorMessage!,
                          textAlign:
                              TextAlign.center,
                        ),
                      ),
                    );
                  }

                
                  // EMPTY
          

                  if (provider.resorts.isEmpty) {
                    return const SizedBox(
                      height: 380,
                      child: Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: [
                            Icon(
                              Icons.hotel,
                              size: 70,
                              color:
                                  Colors.grey,
                            ),

                            SizedBox(
                              height: 15,
                            ),

                            Text(
                              'No Resorts Found',
                              style:
                                  TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

            
                  // HORIZONTAL LIST
                

                  return SizedBox(
                    height: 380,
                    width:
                        double.infinity,

                    child:
                        ScrollConfiguration(
                      behavior:
                          const MaterialScrollBehavior()
                              .copyWith(
                        dragDevices: {
                          PointerDeviceKind
                              .touch,
                          PointerDeviceKind
                              .mouse,
                          PointerDeviceKind
                              .trackpad,
                        },
                      ),

                      child:
                          ListView.separated(
                        scrollDirection:
                            Axis.horizontal,

                        physics:
                            const AlwaysScrollableScrollPhysics(),

                        padding:
                            const EdgeInsets.only(
                          right: 20,
                        ),

                        itemCount:
                            provider
                                .resorts
                                .length,

                        separatorBuilder:
                            (
                          context,
                          index,
                        ) {
                          return const SizedBox(
                            width: 18,
                          );
                        },

                        itemBuilder:
                            (
                          context,
                          index,
                        ) {
                          final resort =
                              provider
                                  .resorts[index];

                          return SizedBox(
                            width: 290,

                            child:
                                FeaturedResortCard(
                              resort:
                                  resort,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}