// // ignore_for_file: one_member_abstracts
//
// void main() {
//   NavGraph.createGraph(
//     startDestination: 'pin-input',
//     setupGraph: (g) => g
//         .route(
//           routeId: 'pin-input',
//           destinations: (d) => d.navigatableTo('pin-setup'),
//         )
//         .route(
//           routeId: 'login',
//           destinations: (d) => d.navigatableTo('pin-setup'),
//         )
//         .route(
//           routeId: 'pin-setup',
//           destinations: (d) => d.navigatableTo('login'),
//         ),
//   );
// }
//
// abstract interface class NavGraphDestinations {
//   NavGraph navigatableTo(String route);
// }
//
// abstract interface class NavGraphRoutes {
//   NavGraph route({
//     required String routeId,
//     required void Function(NavGraphDestinations) destinations,
//   });
// }
//
// class NavGraph implements NavGraphRoutes, NavGraphDestinations {
//   final List<String> _routes = [];
//   final String rootDestination;
//
//   NavGraph({
//     required this.rootDestination,
//   });
//
//   factory NavGraph.createGraph({
//     required String startDestination,
//     required NavGraph Function(NavGraphRoutes) setupGraph,
//   }) {
//     final graph = setupGraph(NavGraph(rootDestination: startDestination));
//     return graph;
//   }
//
//   @override
//   NavGraph route({
//     required String routeId,
//     required void Function(NavGraphDestinations) destinations,
//   }) {
//     return this;
//   }
//
//   @override
//   NavGraph navigatableTo(String destinationRoute) {
//     return this;
//   }
// }
