import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_doc_controller.dart';

class VerifyDocView extends GetView<VerifyDocController> {
  const VerifyDocView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyDocController());
    return Scaffold(
      backgroundColor:
          const Color(0xFFF3F6FC), // Light gray color for a professional look
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'Data Pribadi',
                children: [
                  _buildTextField(
                    controller: controller.nameController,
                    labelText: 'Nama Lengkap',
                    isEnabled: false,
                  ),
                  const SizedBox(height: 16),
                  _buildDatePickerField(
                    context: context,
                    controller: controller.dobController,
                    labelText: 'Tanggal Lahir',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller.phoneController,
                    labelText: 'Nomor Telepon',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller.emailController,
                    labelText: 'Email',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                title: 'Status Pernikahan',
                children: [
                  _buildDropdown(
                    items: ['Belum Menikah', 'Menikah', 'Cerai'],
                    value: controller.maritalStatus.value.isEmpty
                        ? null
                        : controller.maritalStatus.value,
                    onChanged: (value) =>
                        controller.maritalStatus.value = value ?? '',
                    labelText: 'Status Pernikahan',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                title: 'Jumlah Tanggungan',
                children: [
                  _buildDropdown(
                    items: List.generate(11, (index) => index.toString()),
                    value: controller.dependents.value == 0
                        ? null
                        : controller.dependents.value.toString(),
                    onChanged: (value) =>
                        controller.dependents.value = int.parse(value ?? '0'),
                    labelText: 'Jumlah Tanggungan',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                title: 'Informasi Pekerjaan',
                children: [
                  _buildDropdown(
                    items: [
                      'Karyawan',
                      'Wirausaha',
                      'Pengangguran',
                      'Pelajar',
                      'Pensiunan'
                    ],
                    value: controller.jobController.text.isEmpty
                        ? null
                        : controller.jobController.text,
                    onChanged: (value) =>
                        controller.jobController.text = value ?? '',
                    labelText: 'Pekerjaan',
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    items: [
                      'Manajer',
                      'Supervisor',
                      'Staf',
                      'Asisten',
                      'Intern'
                    ],
                    value: controller.positionController.text.isEmpty
                        ? null
                        : controller.positionController.text,
                    onChanged: (value) =>
                        controller.positionController.text = value ?? '',
                    labelText: 'Jabatan',
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    items: ['Karyawan Tetap', 'Karyawan Kontrak'],
                    value: controller.employmentStatus.value.isEmpty
                        ? null
                        : controller.employmentStatus.value,
                    onChanged: (value) =>
                        controller.employmentStatus.value = value ?? '',
                    labelText: 'Status Pekerjaan',
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    items: [
                      '1.000.000 - 2.000.000',
                      '2.000.001 - 3.000.000',
                      '3.000.001 - 4.000.000',
                      '4.000.001 - 5.000.000',
                      'Di atas 5.000.000'
                    ],
                    value: controller.salaryController.text.isEmpty
                        ? null
                        : controller.salaryController.text,
                    onChanged: (value) =>
                        controller.salaryController.text = value ?? '',
                    labelText: 'Rentang Gaji',
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    items: [
                      '0 - 1.000.000',
                      '1.000.001 - 2.000.000',
                      '2.000.001 - 3.000.000',
                      '3.000.001 - 4.000.000',
                      'Di atas 4.000.000'
                    ],
                    value: controller.debtController.text.isEmpty
                        ? null
                        : controller.debtController.text,
                    onChanged: (value) =>
                        controller.debtController.text = value ?? '',
                    labelText: 'Rentang Utang',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await controller.submitForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Kirim'),
              ),
              const SizedBox(height: 32),
              Obx(() {
                if (controller.isApproved.value) {
                  return _buildAnimationMessage('Approved', Colors.green);
                } else if (controller.isRejected.value) {
                  return _buildAnimationMessage('Rejected', Colors.red);
                }
                return SizedBox.shrink(); // No message
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationMessage(String message, Color color) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(seconds: 2),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: TextStyle(
              color: color, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A90E2),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isEnabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: isEnabled ? Colors.white : const Color(0xFFF1F3F6),
      ),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
    required String labelText,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controller.text = "${pickedDate.toLocal()}".split(' ')[0];
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(controller: controller, labelText: labelText),
      ),
    );
  }
}
