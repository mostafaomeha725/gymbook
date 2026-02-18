class BranchData {
  final String imageUrl;
  final String branchName;
  final String location;
  final List<String> tags;
  final int subscriptions;

  const BranchData({
    required this.imageUrl,
    required this.branchName,
    required this.location,
    required this.tags,
    required this.subscriptions,
  });
}

const List<BranchData> branchesList = [
  BranchData(
    imageUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&h=300&fit=crop',
    branchName: 'Nasr City Branch',
    location: '45 Abbas El Akkad, Nasr City, Cairo',
    tags: ['Male', 'Active'],
    subscriptions: 89,
  ),
  BranchData(
    imageUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&h=300&fit=crop',
    branchName: 'Heliopolis Branch',
    location: '78 El Merghany, Heliopolis, Cairo',
    tags: ['Female', 'Active'],
    subscriptions: 112,
  ),
  BranchData(
    imageUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&h=300&fit=crop',
    branchName: 'Zamalek Branch',
    location: '23 26th July St, Zamalek, Cairo',
    tags: ['Mixed', 'Active'],
    subscriptions: 67,
  ),
  BranchData(
    imageUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&h=300&fit=crop',
    branchName: 'Maadi Branch',
    location: '12 Street 9, Maadi, Cairo',
    tags: ['Mixed', 'Active'],
    subscriptions: 145,
  ),
  BranchData(
    imageUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&h=300&fit=crop',
    branchName: 'New Cairo Branch',
    location: '5th Settlement, New Cairo',
    tags: ['Premium', 'Active'],
    subscriptions: 267,
  ),
];
