export interface Menu {
  name: string;
  icon?: string;
  activeIcon?: string;
  subMenu: SubMenu[];
}

export interface SubMenu {
  name: string;
  path?: string;
  type?: string;
  subPath?: string[];
}
