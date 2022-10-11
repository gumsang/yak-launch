import 'dart:io';

import 'package:alyak/domain/model/medicine_model.dart';
import 'package:alyak/main.dart';
import 'package:alyak/presentation/add_alarm_page/add_alarm_page.dart';
import 'package:alyak/presentation/add_medicine_page/components/add_medicine_page_component.dart';
import 'package:alyak/util/dory_constants.dart';
import 'package:alyak/util/dory_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../util/add_page_widget.dart';
import '../components/pick_image_bottomsheet.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({
    super.key,
    this.updateMedicineId = -1,
  });

  final int updateMedicineId;

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  late TextEditingController _nameController;
  File? _medicineImage;

  bool get _isUpdate => widget.updateMedicineId != -1;

  MeidicineModel get _updateMedicine => medicineRepository.medicineBox.values
      .singleWhere((medicine) => medicine.id == widget.updateMedicineId);

  @override
  void initState() {
    super.initState();
    if (_isUpdate) {
      _nameController = TextEditingController(text: _updateMedicine.name);
      if (_updateMedicine.imagePath != null) {
        _medicineImage = File(_updateMedicine.imagePath!);
      }
    } else {
      _nameController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CloseButton(
          color: Colors.black,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: AddPageBody(
            children: [
              Text(
                '무슨 약이고?',
                style: Theme.of(context).textTheme.headline4,
              ),
              const Text(
                '설명: 동그란 사진기 모양을 눌러서 아빠가 먹을 약 사진을 등록.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: largeSpace),
              Center(child: _MedicineImageButton(
                updateImage: _medicineImage,
                changeImageFile: (File? value) {
                  _medicineImage = value;
                },
              )),
              const SizedBox(height: largeSpace + regularSpace),
              Text(
                '약 이름',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextFormField(
                controller: _nameController,
                maxLength: 20,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  hintText: '아빠가 먹을 약 이름을 여기다가 쓰고 다음버튼 클릭.',
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  contentPadding: textfieldContentPadding,
                ),
                //포거스 아웃이 안되어도 텍스트에 변화를 통해 다음버튼 활/비활성화
                onChanged: (_) {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: submitButtonBoxPadding,
          child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle1,
              ),
              onPressed: _nameController.text.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        FadePageRoute(
                          page: AddAlarmPage(
                            updateMedicineId: widget.updateMedicineId,
                            medicineImage: _medicineImage,
                            medicineName: _nameController.text,
                          ),
                        ),
                      );
                    },
              child: const Text('다음'),
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicineImageButton extends StatefulWidget {
  const _MedicineImageButton({required this.changeImageFile, this.updateImage});

  final ValueChanged<File?> changeImageFile;
  final File? updateImage;

  @override
  State<_MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<_MedicineImageButton> {
  File? _pickedImage;
  @override
  void initState() {
    super.initState();
    _pickedImage = widget.updateImage;
  }
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: CupertinoButton(
        padding: _pickedImage == null ? null : EdgeInsets.zero,
        onPressed: _showBottomSheet,
        child: _pickedImage == null
            ? const Icon(
                CupertinoIcons.photo_camera_solid,
                size: 30,
                color: Colors.white,
              )
            : CircleAvatar(
                foregroundImage: FileImage(_pickedImage!),
                radius: 40,
              ),
      ),
    );
  }

  _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          //세이프애리어로 감쌈
          return PickImageBottomSheet(
            onPressedCamera: () => _onPressed(ImageSource.camera),
            onPressedGallery: () => _onPressed(ImageSource.gallery),
          );
        });
  }

  void _onPressed(ImageSource source) {
    ImagePicker().pickImage(source: source).then((xfile) {
      if (xfile != null) {
        setState(() {
          _pickedImage = File(xfile.path);
          widget.changeImageFile(_pickedImage);
        });
      }
      //뭔가 동작을 하면 끄는 코드
      Navigator.maybePop(context);
    }).onError((error, stackTrace) {
      //show setting
      Navigator.pop(context);
      showPermissionDenied(context, permission: '카메라 및 갤러리 접근');
    });
  }
}
