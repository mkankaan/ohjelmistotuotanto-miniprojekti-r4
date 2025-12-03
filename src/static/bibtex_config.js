const typeOptions = [
    { value: 'article', label: 'Article' },
    { value: 'book', label: 'Book' },
    { value: 'inproceedings', label: 'Conference' },
    { value: 'book-chapter', label: 'Book Chapter' },
    { value: 'misc', label: 'Other' }
];

const fieldsByType = {
    article: [
        'year', 'journal', 'volume', 'number',
        'pages', 'doi', 'url', 'urldate'
    ],
    book: [
        'year', 'publisher', 'isbn',
        'doi', 'url', 'urldate'
    ],
    inproceedings: [
        'year', 'booktitle', 'pages',
        'publisher', 'doi', 'url', 'urldate'
    ],
    'book-chapter': [
        'year', 'booktitle', 'chapter', 'pages',
        'publisher', 'doi', 'url', 'urldate'
    ],
    misc: [
        'year', 'publisher', 'doi',
        'url', 'urldate'
    ]
};