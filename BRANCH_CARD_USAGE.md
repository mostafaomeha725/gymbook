# Branch Card Widget

## وصف الـ Widget

`BranchCard` هو widget يعرض معلومات الفرع الواحد (Branch) بشكل جميل وسهل الاستخدام.

## المكونات:
- **صورة الفرع**: صورة إهليليجية في الأعلى
- **اسم الفرع**: مع سهم للتنقل إلى التفاصيل
- **الموقع**: مع أيقونة موقع جغرافي
- **الـ Tags**: باچات ملونة (Active, Mixed, Premium, VIP، وغيرها)
- **عدد الـ Subscriptions**: العدد بلون أزرق muted

## الاستخدام:

```dart
BranchCard(
  imageUrl: 'https://example.com/branch.jpg',
  branchName: 'Maadi Branch',
  location: '12 Street 9, Maadi, Cairo',
  tags: ['Mixed', 'Active'],
  subscriptions: 145,
  onTap: () {
    // التعامل مع النقر على الكارد
  },
)
```

## المعاملات:

| المعامل | النوع | الوصف |
|--------|-------|-------|
| `imageUrl` | String | رابط صورة الفرع |
| `branchName` | String | اسم الفرع |
| `location` | String | موقع الفرع |
| `tags` | List<String> | قائمة الـ tags (Active, Mixed, Premium, VIP) |
| `subscriptions` | int | عدد الـ subscriptions |
| `onTap` | VoidCallback? | الدالة عند النقر على الكارد (اختياري) |

## ألوان الـ Tags:
- **Active**: أخضر (#4CAF50)
- **Mixed**: بنفسجي (#9C27B0)
- **Premium**: أصفر ذهبي (#FFB300)
- **VIP**: وردي (#E91E63)

## مثال للاستخدام:

يمكنك رؤية تطبيق عملي كامل في الملف:
`lib/features/home/presentation/screens/widgets/branch_card_example_screen.dart`

لتجربة المثال، قم بإضافة Route جديدة إلى router أو استبدل أي صفحة موجودة بـ `BranchCardExampleScreen`.
