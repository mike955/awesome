module.exports = {
    title: 'Notes about study and work',
    themeConfig: {
        nav: [
            {text: "api", link: '/'},
            {text: "about", link: '/about'}
        ],
        sidebar: [
            {
                title: 'Daily',
                children: ['/Daily']
            },
            {
                title: 'Devops',
                children: ['/Devops']
            },
            {
                title: 'Docker',
                children: ['/Docker']
            },
            {
                title: 'JavaScript',
                children: ['/Javascript']
            },
            {
                title: 'Kubernetes',
                children: ['/Kubernetes']
            },
            {
                title: 'MongoDB',
                children: ['/MongoDB']
            },
            {
                title: 'Node',
                children: ['/Node/test/supertest.md', '/Node/install_node_nvm.md'],
                sidebar: [
                    {
                        title: 'test',
                        children: ['/Node/test/supertest.md'] 
                    }
                ]
            },
            {
                title: 'Openresty',
                children: ['/Openresty/install_openresty.md']
            },
            {
                title: 'Python',
                children: ['/Python']
            },
            {
                title: 'Redis',
                children: ['/Redis']
            },
            {
                title: 'Shell',
                children: ['/Shell']
            },
            {
                title: 'TodoList',
                children: ['/Todolist']
            },
            {
                title: 'Tools',
                children: ['/Tools']
            }
    ]
    }
}