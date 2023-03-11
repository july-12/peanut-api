# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


User.create([
    { name: 'user', password: '123456a', password_confirmation: '123456a' },
    { name: 'user2', password: '123456a', password_confirmation: '123456a' }
])

user = User.first
user2 = User.last

course = Course.create({ creator: user,  title: 'course', desc: 'create by seed' })
tags = Tag.create([ 
    { creator: user,  course: course,  name: 'tag1', color: "#" + "%06x" % (rand * 0xffffff) },
    { creator: user,  course: course,  name: 'tag2', color: "#" + "%06x" % (rand * 0xffffff) },
    { creator: user,  course: course,  name: 'tag3', color: "#" + "%06x" % (rand * 0xffffff) }
])

posts = Post.create([
    { 
        creator: user,
        course: course,
        title: 'Lorem Ipsum',
        content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
        tags: Tag.first(2)
    },
    { 
        creator: user,
        course: course,
        title: '1914 translation by H. Rackham',
        content: "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain.",
        tags: Tag.last(2)
    },
])

Comment.create([
    {
        creator: user,
        post: Post.first,
        content: 'it \' nice Poem!'
    },
    {
        creator: user2,
        post: Post.first,
        content: 'yeah It is!'
    }
])