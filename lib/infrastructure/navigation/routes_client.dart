import 'package:get/get.dart';
import 'route_names.dart';
import 'transitions/premium_transitions.dart';
import '../../presentation/client/test/test.screen.dart';
import 'bindings/controllers/client.test.controller.binding.dart';

import '../../presentation/client/splash_screen_custom/splash_screen_custom.screen.dart';
import 'bindings/controllers/client.splash_screen_custom.controller.binding.dart';
import '../../presentation/client/inscription/inscription.screen.dart';
import 'bindings/controllers/client.inscription.controller.binding.dart';
import '../../presentation/client/login/login.screen.dart';
import 'bindings/controllers/client.login.controller.binding.dart';
import '../../presentation/client/home/home.screen.dart';
import 'bindings/controllers/client.home.controller.binding.dart';
import '../../presentation/client/verification_identity/verification_identity.screen.dart';
import 'bindings/controllers/client.verification_identity.controller.binding.dart';
import '../../presentation/client/forget_password/forget_password.screen.dart';
import 'bindings/controllers/client.forget_password.controller.binding.dart';

import '../../presentation/client/update_password/update_password.screen.dart';
import 'bindings/controllers/client.update_password.controller.binding.dart';
import '../../presentation/client/dashboard/dashboard.screen.dart';
import 'bindings/controllers/client.dashboard.controller.binding.dart';
import '../../presentation/client/reservations/reservations.screen.dart';
import 'bindings/controllers/client.reservations.controller.binding.dart';
import '../../presentation/client/favoris/favoris.screen.dart';
import 'bindings/controllers/client.favoris.controller.binding.dart';
import '../../presentation/client/messages/messages.screen.dart';
import 'bindings/controllers/client.messages.controller.binding.dart';
import '../../presentation/client/profil/profil.screen.dart';
import 'bindings/controllers/client.profil.controller.binding.dart';

import '../../presentation/client/details_reservations/details_reservations.screen.dart';
import 'bindings/controllers/client.details_reservations.controller.binding.dart';
import '../../presentation/client/conversation/conversation.screen.dart';
import 'bindings/controllers/client.conversation.controller.binding.dart';
import '../../presentation/client/informations_personnelles/informations_personnelles.screen.dart';
import 'bindings/controllers/client.informations_personnelles.controller.binding.dart';
import '../../presentation/client/historique/historique.screen.dart';
import 'bindings/controllers/client.historique.controller.binding.dart';
import '../../presentation/client/parametres/parametres.screen.dart';
import 'bindings/controllers/client.parametres.controller.binding.dart';
import '../../presentation/client/termes_utilisation/termes_utilisation.screen.dart';
import 'bindings/controllers/client.termes_utilisation.controller.binding.dart';
import '../../presentation/client/politique_confidentialite/politique_confidentialite.screen.dart';
import 'bindings/controllers/client.politique_confidentialite.controller.binding.dart';
import '../../presentation/client/Utilisation_donnees/Utilisation_donnees.screen.dart';
import 'bindings/controllers/client.Utilisation_donnees.controller.binding.dart';
import '../../presentation/shared/successPage/success_page.screen.dart';
import 'bindings/controllers/success_page.controller.binding.dart';

import '../../presentation/client/securite/securite.screen.dart';
import 'bindings/controllers/client.securite.controller.binding.dart';
import '../../presentation/client/langue/langue.screen.dart';
import 'bindings/controllers/client.langue.controller.binding.dart';
import '../../presentation/client/details_logement/details_logement.screen.dart';
import 'bindings/controllers/client.details_logement.controller.binding.dart';
import '../../presentation/client/reservation_steps/reservation_steps.screen.dart';
import 'bindings/controllers/client.reservation_steps.controller.binding.dart';
import '../../presentation/client/splash_screen_custom2/splash_screen_custom2.screen.dart';
import 'bindings/controllers/client.splash_screen_custom2.controller.binding.dart';
import '../../presentation/client/result_search/result_search.screen.dart';
import 'bindings/controllers/client.result_search.controller.binding.dart';
class RoutesClient {
  static List<GetPage> get pages => <GetPage>[

    GetPage(
      name: RouteNames.clientTest,
      page: () => const TestScreen(),
      binding: ClientTestControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientSplashScreenCustom,
      page: () => const SplashScreenCustomScreen(),
      binding: ClientSplashScreenCustomControllerBinding(),
      customTransition: PremiumTransitions.fade,
      transitionDuration: PremiumTransitions.standardDuration,
    ),
    GetPage(
      name: RouteNames.clientSplashScreenCustom2,
      page: () => const SplashScreenCustom2Screen(),
      binding: ClientSplashScreenCustom2ControllerBinding(),
      customTransition: PremiumTransitions.fade,
      transitionDuration: PremiumTransitions.standardDuration,
    ),
    GetPage(
      name: RouteNames.clientInscription,
      page: () => const InscriptionScreen(),
      binding: ClientInscriptionControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientLogin,
      page: () => const LoginScreen(),
      binding: ClientLoginControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientVerificationIdentity,
      page: () => const VerificationIdentityScreen(),
      binding: ClientVerificationIdentityControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientForgetPassword,
      page: () => const ForgetPasswordScreen(),
      binding: ClientForgetPasswordControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientUpdatePassword,
      page: () => const UpdatePasswordScreen(),
      binding: ClientUpdatePasswordControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientHome,
      page: () => const HomeScreen(),
      binding: ClientHomeControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientDashboard,
      page: () => const DashboardScreen(),
      binding: ClientDashboardControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientReservations,
      page: () => const ReservationsScreen(),
      binding: ClientReservationsControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientFavoris,
      page: () => const FavorisScreen(),
      binding: ClientFavorisControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientMessages,
      page: () => const MessagesScreen(),
      binding: ClientMessagesControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientProfil,
      page: () => const ProfilScreen(),
      binding: ClientProfilControllerBinding(),
    ),

    GetPage(
      name: RouteNames.clientDetailsReservations,
      page: () => const DetailsReservationsScreen(),
      binding: ClientDetailsReservationsControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientDetailsLogement,
      page: () => const DetailsLogementScreen(),
      binding: ClientDetailsLogementControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientReservationSteps,
      page: () => const ReservationStepsScreen(),
      binding: ClientReservationStepsControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientConversation,
      page: () => ConversationScreen(),
      binding: ClientConversationControllerBinding(),
    ),

    GetPage(
      name: RouteNames.clientInformationsPersonnelles,
      page: () => const InformationsPersonnellesScreen(),
      binding: ClientInformationsPersonnellesControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientHistorique,
      page: () => const HistoriqueScreen(),
      binding: ClientHistoriqueControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientParametres,
      page: () => const ParametresScreen(),
      binding: ClientParametresControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientSecurite,
      page: () => const SecuriteScreen(),
      binding: ClientSecuriteControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientLangue,
      page: () => const LangueScreen(),
      binding: ClientLangueControllerBinding(),
    ),

    GetPage(
      name: RouteNames.clientTermesUtilisation,
      page: () => const TermesUtilisationScreen(),
      binding: ClientTermesUtilisationControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientPolitiqueConfidentialite,
      page: () => const PolitiqueConfidentialiteScreen(),
      binding: ClientPolitiqueConfidentialiteControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientUtilisationDonnees,
      page: () => const UtilisationDonneesScreen(),
      binding: ClientUtilisationDonneesControllerBinding(),
    ),
    GetPage(
      name: RouteNames.clientResultSearch,
      page: () => const ResultSearchScreen(),
      binding: ClientResultSearchControllerBinding(),
    ),
    GetPage(
      name: RouteNames.sharedSuccessPage,
      page: () => const SuccessPageScreen(),
      binding: SuccessPageControllerBinding(),

    ),
  ];
}

