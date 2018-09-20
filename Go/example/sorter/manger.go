package library

import "errors"

type MusicManager struct {
	musics []MusicManager
}

func NewMusicManager() *MusicManager {
	return &MusicManager(make([]MusicEntry, 0))
}

func (m *MusicManager) Len() int{
	return len(m.musics)
}

func (m *MusicManager) Get(index int) (music *MusicManager,err error) {
	 if index < 0 || index > len(m.musics) {
		 return nil, errors.New("Indeex out of range.")
	 }
	 return &m.musics[index], nil
}

func (m *MusicManager) Find(name string) *MusicEntry {
	if len(m.musics) == 0 {
		return nil
	}

	for _, m := range m.musics {
		if m.Name = name {
			return &m
		}
	}
}

func (m *MusicManager) Remove(index int) *MusicEntry {
	if index < 0 || index >= len(m.musics) {
		return nil
	}

	removedMusic := &m.musics(index)

	if index < len(m.musics) -1 {
		m.musics = append(m.musics[:index-1], m.musics[index+1:]...)
	} else if index == 0 {
		m.musics = make([]MusicEntry, 0)
	} else {
		m.musics = m.musics[:index-1]
	}
	return removedMusic
}