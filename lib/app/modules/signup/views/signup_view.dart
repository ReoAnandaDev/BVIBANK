import 'package:bvibank/app/modules/login/views/login_view.dart';
import 'package:bvibank/app/services/wilayah_model.dart';
import 'package:bvibank/app/services/wilayah_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final WilayahService _wilayahService = WilayahService();
  final SignupController controller = Get.put(SignupController());

  final _isPasswordVisible = false.obs;
  final _isConfirmPasswordVisible = false.obs;
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Dropdown values
  WilayahModel? selectedProvince;
  WilayahModel? selectedRegency;
  WilayahModel? selectedDistrict;
  WilayahModel? selectedVillage;

  // Lists
  List<WilayahModel> provinces = [];
  List<WilayahModel> regencies = [];
  List<WilayahModel> districts = [];
  List<WilayahModel> villages = [];

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  Future<void> _fetchProvinces() async {
    try {
      final result = await _wilayahService.getProvinces();
      setState(() {
        provinces = result;
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> _fetchRegencies(String provinceCode) async {
    try {
      final result =
          await _wilayahService.getRegenciesByProvinceCode(provinceCode);
      setState(() {
        regencies = result;
        selectedRegency = null;
        selectedDistrict = null;
        selectedVillage = null;
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> _fetchDistricts(String regencyCode) async {
    try {
      final result =
          await _wilayahService.getDistrictsByRegencyCode(regencyCode);
      setState(() {
        districts = result;
        selectedDistrict = null;
        selectedVillage = null;
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> _fetchVillages(String districtCode) async {
    try {
      final result =
          await _wilayahService.getVillagesByDistrictCode(districtCode);
      setState(() {
        villages = result;
        selectedVillage = null;
        _postalCodeController.text =
            result.isNotEmpty ? result.first.postalCode ?? '' : '';
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/image/backgroundfinger.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Create Account',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ' Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.endsWith('@gmail.com')) {
                        return 'Email must end with @gmail.com';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      hintText: 'Enter your phone number (e.g., 628123456789)',
                      counterText: '',
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLength: 15,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      // Validasi format tanpa tanda +
                      if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                        return 'Please enter a valid phone number without "+"';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  DropdownButtonFormField<WilayahModel>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Provinsi',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    isExpanded: true,
                    hint: Text('Pilih Provinsi'),
                    value: selectedProvince,
                    items: provinces.map((province) {
                      return DropdownMenuItem(
                        value: province,
                        child: Text(province.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProvince = value;
                        _fetchRegencies(value!.code);
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Pilih Provinsi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Kabupaten/Kota
                  DropdownButtonFormField<WilayahModel>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Kota/Kabupaten',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    isExpanded: true,
                    hint: Text('Pilih Kota/Kabupaten'),
                    value: selectedRegency,
                    items: regencies.map((regency) {
                      return DropdownMenuItem(
                        value: regency,
                        child: Text(regency.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRegency = value;
                        _fetchDistricts(value!.code);
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Pilih Kota/Kabupaten' : null,
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Kecamatan
                  DropdownButtonFormField<WilayahModel>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Kecamatan',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    isExpanded: true,
                    hint: Text('Pilih Kecamatan'),
                    value: selectedDistrict,
                    items: districts.map((district) {
                      return DropdownMenuItem(
                        value: district,
                        child: Text(district.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value;
                        _fetchVillages(value!.code);
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Pilih Kecamatan' : null,
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Kelurahan
                  DropdownButtonFormField<WilayahModel>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Kelurahan',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    isExpanded: true,
                    hint: Text('Pilih Kelurahan'),
                    value: selectedVillage,
                    items: villages.map((village) {
                      return DropdownMenuItem(
                        value: village,
                        child: Text(village.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVillage = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Pilih Kelurahan' : null,
                  ),
                  const SizedBox(height: 16),

                  // Input Alamat Lengkap
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Alamat Lengkap',
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Input Kode Pos
                  TextFormField(
                    controller: _postalCodeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Kode Pos',
                      prefixIcon: Icon(Icons.code),
                    ),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kode pos akan otomatis terisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Obx(() => TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              _isPasswordVisible.value =
                                  !_isPasswordVisible.value;
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                              .hasMatch(value)) {
                            return 'Password must include uppercase, lowercase, numbers, and special characters';
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 16),

                  Obx(() => TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              _isConfirmPasswordVisible.value =
                                  !_isConfirmPasswordVisible.value;
                            },
                          ),
                        ),
                        obscureText: !_isConfirmPasswordVisible.value,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          controller.signup(
                            _emailController.text,
                            _passwordController.text,
                            _phoneController.text,
                            _fullNameController.text,
                            _addressController.text,
                            selectedVillage?.name ?? '',
                            selectedDistrict?.name ?? '',
                            selectedRegency?.name ?? '',
                            selectedProvince?.name ?? '',
                            _postalCodeController.text,
                          );
                        }
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Get.offAll(() => LoginView());
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
