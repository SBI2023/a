
import '../../domain/models/choice_screen_model.dart';
import '../env/env.dart';

class ChoiceScreenRepository {
  ChoiceScreenModel fetchBoxsData() {
    // Here you can call the API to fetch data
    // For this example, we will return hardcoded data

    return ChoiceScreenModel(
      boxs: [
        BoxModel(
          // boxImage: "https://tunewtec.com/wp-content/uploads/2023/01/alpha-iptv.jpeg.webp",
          boxImage: "${Environment.assetsPath}alpha_logo.png",
          api: "",
        ),
        BoxModel(
          // boxImage: "https://scontent.ftun15-1.fna.fbcdn.net/v/t39.30808-6/324339561_739517734049065_4323188824913695293_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=174925&_nc_ohc=l27Y-ZJ6RXwAX9xkxIM&tn=gBBITPahf-SLMFkR&_nc_ht=scontent.ftun15-1.fna&oh=00_AfBo8yHUpn_K-SCY2MZ1mi6nB5b5f9rJYVRHrdwsSt0DrA&oe=63FD2F39",
          boxImage: "${Environment.assetsPath}diwansport_slider.jpg",

          api: "",
        ),
        BoxModel(
          // boxImage: "https://scontent.ftun15-1.fna.fbcdn.net/v/t39.30808-6/324339561_739517734049065_4323188824913695293_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=174925&_nc_ohc=l27Y-ZJ6RXwAX9xkxIM&tn=gBBITPahf-SLMFkR&_nc_ht=scontent.ftun15-1.fna&oh=00_AfBo8yHUpn_K-SCY2MZ1mi6nB5b5f9rJYVRHrdwsSt0DrA&oe=63FD2F39",
          boxImage: "",

          api: "",
        ),
        BoxModel(
          // boxImage: "https://scontent.ftun15-1.fna.fbcdn.net/v/t39.30808-6/324339561_739517734049065_4323188824913695293_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=174925&_nc_ohc=l27Y-ZJ6RXwAX9xkxIM&tn=gBBITPahf-SLMFkR&_nc_ht=scontent.ftun15-1.fna&oh=00_AfBo8yHUpn_K-SCY2MZ1mi6nB5b5f9rJYVRHrdwsSt0DrA&oe=63FD2F39",
          boxImage: "",

          api: "",
        ),
        BoxModel(
          // boxImage: "https://scontent.ftun15-1.fna.fbcdn.net/v/t39.30808-6/324339561_739517734049065_4323188824913695293_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=174925&_nc_ohc=l27Y-ZJ6RXwAX9xkxIM&tn=gBBITPahf-SLMFkR&_nc_ht=scontent.ftun15-1.fna&oh=00_AfBo8yHUpn_K-SCY2MZ1mi6nB5b5f9rJYVRHrdwsSt0DrA&oe=63FD2F39",
          boxImage: "",

          api: "",
        ),
        BoxModel(
          // boxImage: "https://scontent.ftun15-1.fna.fbcdn.net/v/t39.30808-6/324339561_739517734049065_4323188824913695293_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=174925&_nc_ohc=l27Y-ZJ6RXwAX9xkxIM&tn=gBBITPahf-SLMFkR&_nc_ht=scontent.ftun15-1.fna&oh=00_AfBo8yHUpn_K-SCY2MZ1mi6nB5b5f9rJYVRHrdwsSt0DrA&oe=63FD2F39",
          boxImage: "",

          api: "",
        ),
      ],
      indexClicked: 0,
      // backgroundImage: "https://cdn.fansshare.com/images/background/blue-background-high-res-wallpaper-blue-266286561.jpg",
      backgroundImage: "${Environment.assetsPath}background_choice_screen.jpg",
    );
  }
}
