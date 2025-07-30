import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/Model/User.dart';
import 'package:screen_page/Provider/UserProvider.dart';
import 'package:screen_page/service/Worker.dart';

class ManageServicesPage extends StatefulWidget {
  const ManageServicesPage({super.key});

  @override
  State<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Service> _services = [
    Service(
      title: "Home Plumbing Expert",
      description: "Fixing leaks, installing sinks and more.",
      category: "Plumbing",
      duration: 2,
      experience: 5,
      price: 2000,
      education: "Vocational Training",
      location: "Blida",
      photo: "profile_photo.jpg",
    ),
  ];

  // Form controllers
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _educationLevel = "Select education level";
  String _location = "Select wilaya";
  List<String> _uploadedDocuments = [];
  String? _profilePhoto;

  // List of Algerian wilayas
  final List<String> _wilayas = [
    "Select wilaya",
    "Adrar",
    "Chlef",
    "Laghouat",
    "Oum El Bouaghi",
    "Batna",
    "Béjaïa",
    "Biskra",
    "Béchar",
    "Blida",
    "Bouira",
    "Tamanrasset",
    "Tébessa",
    "Tlemcen",
    "Tiaret",
    "Tizi Ouzou",
    "Algiers",
    "Djelfa",
    "Jijel",
    "Sétif",
    "Saïda",
    "Skikda",
    "Sidi Bel Abbès",
    "Annaba",
    "Guelma",
    "Constantine",
    "Médéa",
    "Mostaganem",
    "M'Sila",
    "Mascara",
    "Ouargla",
    "Oran",
    "El Bayadh",
    "Illizi",
    "Bordj Bou Arréridj",
    "Boumerdès",
    "El Tarf",
    "Tindouf",
    "Tissemsilt",
    "El Oued",
    "Khenchela",
    "Souk Ahras",
    "Tipaza",
    "Mila",
    "Aïn Defla",
    "Naâma",
    "Aïn Témouchent",
    "Ghardaïa",
    "Relizane",
  ];

  @override
  void dispose() {
    _categoryController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _experienceController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Services")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCreateNewServiceSection(context),
            _buildYourServicesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewServiceSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create New Service",
                style: TextStyle(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: isTablet ? 8 : 4),
              Text(
                "Add your professional service details",
                style: TextStyle(
                  color: const Color.fromARGB(255, 17, 98, 3),
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
              SizedBox(height: isTablet ? 24 : 16),

              // Photo Upload Section
              _buildPhotoUploadSection(context),
              SizedBox(height: isTablet ? 24 : 16),

              // Basic Info Section
              _buildSectionTitle(context, "Basic Information"),
              SizedBox(height: isTablet ? 16 : 12),
              _buildFormField(
                _categoryController,
                "Category",
                "e.g., Plumbing, Electrical",
                Icons.category,
                validator: _validateRequired,
              ),
              SizedBox(height: isTablet ? 16 : 12),
              _buildFormField(
                _titleController,
                "Service Title",
                "e.g., Home Plumbing Expert",
                Icons.title,
                validator: _validateRequired,
              ),
              SizedBox(height: isTablet ? 16 : 12),
              _buildFormField(
                _descriptionController,
                "Description",
                "Brief description of your service",
                Icons.description,
                maxLines: 3,
                validator: _validateRequired,
              ),

              SizedBox(height: isTablet ? 24 : 16),

              // Professional Details
              _buildSectionTitle(context, "Professional Details"),
              SizedBox(height: isTablet ? 16 : 12),
              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      _durationController,
                      "Duration (hours)",
                      "2",
                      Icons.schedule,
                      validator: _validateNumber,
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: _buildFormField(
                      _experienceController,
                      "Experience (years)",
                      "5",
                      Icons.work,
                      validator: _validateNumber,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              _buildFormField(
                _priceController,
                "Starting Price (DZD)",
                "2000",
                Icons.attach_money,
                validator: _validateNumber,
              ),
              SizedBox(height: isTablet ? 16 : 12),
              _buildDropdownField(
                "Education Level",
                [
                  "Select education level",
                  "High School",
                  "Vocational Training",
                  "Bachelor's Degree",
                  "Master's Degree",
                ],
                _educationLevel,
                (value) {
                  setState(() {
                    _educationLevel = value!;
                  });
                },
              ),
              SizedBox(height: isTablet ? 16 : 12),
              _buildDropdownField("Location (Wilaya)", _wilayas, _location, (
                value,
              ) {
                setState(() {
                  _location = value!;
                });
              }),

              SizedBox(height: isTablet ? 24 : 16),

              // Documents Section
              _buildDocumentUploadSection(context),

              SizedBox(height: isTablet ? 24 : 16),
              SizedBox(
                width: double.infinity,
                height: isTablet ? 50 : 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if ((_formKey.currentState!.validate() &&
                        _location != "Select wilaya" &&
                        _profilePhoto != null)) {
                      String token =
                          await Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).get_token;
                      Map<String, dynamic> creds = {
                        "category": _categoryController.text,
                        "title": _titleController.text,
                        "description": _descriptionController.text,
                        "duration": _durationController.text,
                        "experienceYears": _experienceController.text,
                        "previousWorkplaces": ["AquaFix", "PlumbCo"],
                        "educationLevel": _educationLevel,
                        "skillLevel": "Advanced",
                        "startingPrice": _priceController.text,
                        "files": [],
                        "location": {
                          "type": _location,
                          "coordinates": [2.866, 36.75],
                        },
                        "isActive": true,
                        "bio":
                            "Certified plumber with 5 years of residential experience.",
                        "services": [
                          "Leak Repair",
                          "Drain Cleaning",
                          "Sink Installation",
                        ],
                      };
                      Worker.addService(token, creds);
                    }
                    _addService();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Create Service",
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 10 : 8),
                decoration: BoxDecoration(
                  color: Colors.amber[600]!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.amber[600],
                  size: isTablet ? 24 : 20,
                ),
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Text(
                "Profile Photo *",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            "Upload your professional profile photo",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isTablet ? 14 : 12,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Row(
            children: [
              Container(
                width: isTablet ? 100 : 80,
                height: isTablet ? 100 : 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child:
                    _profilePhoto != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: isTablet ? 40 : 32,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        )
                        : Icon(
                          Icons.add_a_photo,
                          size: isTablet ? 32 : 24,
                          color: Colors.grey[500],
                        ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickPhoto,
                      icon: Icon(Icons.camera_alt, size: isTablet ? 20 : 18),
                      label: Text(
                        _profilePhoto != null ? "Change Photo" : "Add Photo",
                        style: TextStyle(fontSize: isTablet ? 16 : 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20 : 16,
                          vertical: isTablet ? 12 : 10,
                        ),
                      ),
                    ),
                    if (_profilePhoto != null) ...[
                      SizedBox(height: isTablet ? 8 : 6),
                      Text(
                        _profilePhoto!,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Text(
      title,
      style: TextStyle(
        fontSize: isTablet ? 20 : 16,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 15, 1, 108),
      ),
    );
  }

  Widget _buildDocumentUploadSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 10 : 8),
                decoration: BoxDecoration(
                  color: Colors.amber[600]!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.file_upload,
                  color: Colors.amber[600],
                  size: isTablet ? 24 : 20,
                ),
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Text(
                "Certificates & Documents",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            "Upload certificates, degrees, or relevant documents",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isTablet ? 14 : 12,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          OutlinedButton.icon(
            onPressed: _pickDocument,
            icon: Icon(Icons.add, size: isTablet ? 20 : 18),
            label: Text(
              "Add Document",
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.amber[600],
              side: BorderSide(color: Colors.amber[600]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 12 : 10,
              ),
            ),
          ),
          if (_uploadedDocuments.isNotEmpty) ...[
            SizedBox(height: isTablet ? 16 : 12),
            ..._uploadedDocuments
                .map(
                  (doc) => Container(
                    margin: EdgeInsets.only(bottom: isTablet ? 10 : 8),
                    padding: EdgeInsets.all(isTablet ? 14 : 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: Colors.grey[600],
                          size: isTablet ? 22 : 18,
                        ),
                        SizedBox(width: isTablet ? 10 : 8),
                        Expanded(
                          child: Text(
                            doc,
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                            size: isTablet ? 20 : 16,
                          ),
                          onPressed: () => _removeDocument(doc),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildYourServicesSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Services",
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: isTablet ? 20 : 16),
            if (_services.isEmpty)
              Container(
                padding: EdgeInsets.all(isTablet ? 32 : 24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: isTablet ? 48 : 40,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      Text(
                        "No services yet",
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ..._services
                .map((service) => _buildServiceCard(service, context))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Service service, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Profile photo
                Container(
                  width: isTablet ? 60 : 50,
                  height: isTablet ? 60 : 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        service.photo.isNotEmpty
                            ? Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: isTablet ? 30 : 24,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                            : Icon(
                              Icons.person,
                              size: isTablet ? 30 : 24,
                              color: Colors.grey[500],
                            ),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: isTablet ? 6 : 4),
                      Text(
                        service.category,
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.amber[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, size: isTablet ? 24 : 20),
                      onPressed: () => _editService(service),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.amber[600]!.withOpacity(0.1),
                        foregroundColor: Colors.amber[600],
                      ),
                    ),
                    SizedBox(width: isTablet ? 10 : 8),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: isTablet ? 24 : 20,
                      ),
                      onPressed: () => _deleteService(service),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.1),
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              service.description,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Wrap(
              spacing: isTablet ? 12 : 8,
              runSpacing: isTablet ? 12 : 8,
              children: [
                _buildTag("${service.duration}h", Colors.amber[600]!),
                _buildTag("${service.experience} years", Colors.blue[400]!),
                _buildTag("${service.price} DZD", Colors.green[400]!),
                if (service.location.isNotEmpty)
                  _buildTag(service.location, Colors.purple[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFormField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: isTablet ? 16 : 14,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(fontSize: isTablet ? 16 : 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: isTablet ? 16 : 14,
            ),
            prefixIcon: Icon(
              icon,
              size: isTablet ? 24 : 20,
              color: Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.amber[600]!, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isTablet ? 16 : 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> options,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: isTablet ? 16 : 14,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        DropdownButtonFormField<String>(
          value: value,
          items:
              options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: isTablet ? 16 : 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
          onChanged: onChanged,
          style: TextStyle(fontSize: isTablet ? 16 : 14),
          decoration: InputDecoration(
            prefixIcon:
                label == "Location (Wilaya)"
                    ? Icon(
                      Icons.location_on,
                      size: isTablet ? 24 : 20,
                      color: Colors.grey[600],
                    )
                    : Icon(
                      Icons.school,
                      size: isTablet ? 24 : 20,
                      color: Colors.grey[600],
                    ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 241, 212, 106)!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.amber[600]!, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isTablet ? 16 : 12,
            ),
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void _pickPhoto() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              "Select Photo",
              style: TextStyle(color: Colors.grey[800]),
            ),
            content: Text(
              "Choose how you want to add your profile photo.",
              style: TextStyle(color: Colors.grey[600]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _profilePhoto =
                        "profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg";
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Photo added successfully'),
                      backgroundColor: Colors.amber[600],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Add Sample Photo"),
              ),
            ],
          ),
    );
  }

  void _pickDocument() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              "Add Document",
              style: TextStyle(color: Colors.grey[800]),
            ),
            content: Text(
              "Select the type of document you want to add.",
              style: TextStyle(color: Colors.grey[600]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _uploadedDocuments.add(
                      "Certificate_${_uploadedDocuments.length + 1}.pdf",
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Document added successfully'),
                      backgroundColor: Colors.amber[600],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Add Sample"),
              ),
            ],
          ),
    );
  }

  void _removeDocument(String document) {
    setState(() {
      _uploadedDocuments.remove(document);
    });
  }

  _addService() {
    if (_formKey.currentState!.validate() &&
        _location != "Select wilaya" &&
        _profilePhoto != null) {
      setState(() {
        _services.add(
          Service(
            title: _titleController.text,
            description: _descriptionController.text,
            category: _categoryController.text,
            duration: int.parse(_durationController.text),
            experience: int.parse(_experienceController.text),
            price: int.parse(_priceController.text),
            education:
                _educationLevel == "Select education level"
                    ? ""
                    : _educationLevel,
            location: _location,
            documents: List.from(_uploadedDocuments),
            photo: _profilePhoto!,
          ),
        );

        // Clear the form
        _categoryController.clear();
        _titleController.clear();
        _descriptionController.clear();
        _durationController.clear();
        _experienceController.clear();
        _priceController.clear();
        _educationLevel = "Select education level";
        _location = "Select wilaya";
        _uploadedDocuments.clear();
        _profilePhoto = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Service created successfully!'),
          backgroundColor: Colors.amber[600],
        ),
      );
    } else if (_location == "Select wilaya") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a wilaya'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (_profilePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add your profile photo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editService(Service service) {
    _categoryController.text = service.category;
    _titleController.text = service.title;
    _descriptionController.text = service.description;
    _durationController.text = service.duration.toString();
    _experienceController.text = service.experience.toString();
    _priceController.text = service.price.toString();
    _educationLevel =
        service.education.isEmpty
            ? "Select education level"
            : service.education;
    _location = service.location;
    _uploadedDocuments = List.from(service.documents);
    _profilePhoto = service.photo;

    Scrollable.ensureVisible(
      _formKey.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _deleteService(Service service) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              "Delete Service",
              style: TextStyle(color: Colors.grey[800]),
            ),
            content: Text(
              "Are you sure you want to delete this service? This action cannot be undone.",
              style: TextStyle(color: Colors.grey[600]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String token =
                      await Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).get_token;
                  User user =
                      await Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).get_user;
                  await Worker.deleteService(user.id, token);
                  setState(() {
                    _services.remove(service);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Service deleted'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }
}

class Service {
  final String title;
  final String description;
  final String category;
  final int duration;
  final int experience;
  final int price;
  final String education;
  final String location;
  final List<String> documents;
  final String photo;

  Service({
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.experience,
    required this.price,
    this.education = '',
    this.location = '',
    this.documents = const [],
    this.photo = '',
  });
}
