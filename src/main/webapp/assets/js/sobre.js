document.addEventListener('DOMContentLoaded', function () {
    const faqItems = document.querySelectorAll('.faq-item');

    faqItems.forEach(item => {
        const question = item.querySelector('.faq-question');
        if (question) {
            question.addEventListener('click', () => {
                toggleAccordion(item);
            });

            question.addEventListener('keydown', e => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    toggleAccordion(item);
                }
            });
        }
    });

    function toggleAccordion(item) {
        const answer = item.querySelector('.faq-answer');
        const question = item.querySelector('.faq-question');
        const isExpanded = question.getAttribute('aria-expanded') === 'true';

        if (isExpanded) {
            item.classList.remove('open');
            question.setAttribute('aria-expanded', 'false');
            answer.setAttribute('hidden', '');
        } else {
            item.classList.add('open');
            question.setAttribute('aria-expanded', 'true');
            answer.removeAttribute('hidden');
        }
    }
});